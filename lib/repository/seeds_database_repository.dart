import 'package:seed/exceptions/db_cannot_insert_data_exception.dart';
import 'package:seed/exceptions/db_does_not_clear_table_exception.dart';
import 'package:seed/repository/seeds_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_provider.dart';
import '../database/seed_dao.dart';
import '../models/database_seed.dart';

class SeedsDatabaseRepository implements SeedsRepository {
  SeedsDatabaseRepository(this.databaseProvider);

  final dao = SeedDao();
  @override
  DatabaseProvider databaseProvider;

  @override
  Future<void> insert(DatabaseSeed seed) async {
    try {
      final db = await databaseProvider.db();
      await db.insert(dao.tableName, dao.toMap(seed),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (error) {
      throw DbCannotInsertDataException();
    }
  }

  @override
  Future<void> clear() async {
    try {
      final db = await databaseProvider.db();
      await db.delete(dao.tableName);
    } catch (error) {
      throw DbDoesNotClearTableException();
    }
  }

  @override
  Future<void> update(DatabaseSeed seed) async {
    try {
      final db = await databaseProvider.db();
      await db.update(dao.tableName, dao.toMap(seed),
          where: '${dao.columnId} = ?', whereArgs: [seed.id]);
    } catch (error) {
      throw DbCannotInsertDataException();
    }
  }

  @override
  Future<List<DatabaseSeed>> getSeeds() async {
    final db = await databaseProvider.db();
    List<Map<String, dynamic>> maps = await db.query(dao.tableName);
    return dao.fromList(maps);
  }

  @override
  Future<List<DatabaseSeed>> getNonSynchronizedSeeds() async {
    final db = await databaseProvider.db();

    final List<Map<String, dynamic>> maps = await db.query(
      dao.tableName,
      where: '${dao.columnSynchronized} = ?',
      whereArgs: [0],
    );

    return List.generate(maps.length, (index) => dao.fromMap(maps[index]));
  }

  @override
  Future<List<DatabaseSeed>> searchSeeds(String query) async {
    final db = await databaseProvider.db();

    final List<Map<String, dynamic>> maps = await db.query(
      dao.tableName,
      where: '${dao.columnName} LIKE ? or ${dao.columnManufacturer} LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return List.generate(maps.length, (index) => dao.fromMap(maps[index]));
  }
}
