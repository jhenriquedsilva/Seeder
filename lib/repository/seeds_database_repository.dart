import 'package:seed/models/seed.dart';
import 'package:seed/repository/seeds_repository.dart';

import '../database/database_provider.dart';
import '../database/seed_dao.dart';

class SeedsDatabaseRepository implements SeedsRepository {
  SeedsDatabaseRepository(this.databaseProvider);

  final dao = SeedDao();
  @override
  DatabaseProvider databaseProvider;

  @override
  Future<void> insert(Seed seed) async {
    final db = await databaseProvider.db();
    await db.insert(dao.tableName, dao.toMap(seed));
  }

  @override
  Future<void> clear(Seed seed) async {
    final db = await databaseProvider.db();
    await db.delete(dao.tableName);
  }

  @override
  Future<void> update(Seed seed) async {
    final db = await databaseProvider.db();
    await db.update(dao.tableName,
        dao.toMap(seed),
        where: '${dao.columnId} = ?', whereArgs: [seed.id]);
  }

  @override
  Future<List<Seed>> getSeeds() async {
    final db = await databaseProvider.db();
    List<Map<String, dynamic>> maps = await db.query(dao.tableName);
    return dao.fromList(maps);
  }

  @override
  Future<List<Seed>> getNonSynchronizedSeeds() async {
    final db = await databaseProvider.db();

    final List<Map<String, dynamic>> maps = await db.query(
      dao.tableName,
      where: '${dao.columnSynchronized} = ?',
      whereArgs: [0],
    );

    return List.generate(
        maps.length, (index) => dao.fromMap(maps[index]));
  }

  @override
  Future<List<Seed>> searchSeeds(String query) async {
    final db = await databaseProvider.db();

    final List<Map<String, dynamic>> maps = await db.query(
      dao.tableName,
      where: '${dao.columnName} LIKE ? or ${dao.columnManufacturer} LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return List.generate(
        maps.length, (index) => dao.fromMap(maps[index]));
  }
}