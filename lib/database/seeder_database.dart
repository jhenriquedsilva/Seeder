import 'package:path/path.dart';
import 'package:seed/models/database_seed.dart';
import 'package:sqflite/sqflite.dart';

class SeederDatabase {
  Future<Database> _getInstance() async {
    return openDatabase(
        join(
          await getDatabasesPath(),
          'seeder_database.db',
        ), onCreate: (seedDatabase, version) async {
      await seedDatabase.execute(
        'CREATE TABLE seeds('
        'id TEXT PRIMARY KEY, '
        'name TEXT NOT NULL, '
        'manufacturer TEXT NOT NULL, '
        'manufacturedAt TEXT NOT NULL, '
        'expiresIn TEXT NOT NULL, '
        'createdAt TEXT NOT NULL, '
        'synchronized INTEGER NOT NULL'
        ')',
      );
    }, version: 1);
  }

  Future<void> insert(DatabaseSeed databaseSeed) async {
    final db = await _getInstance();

    await db.insert(
      'seeds',
      databaseSeed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(DatabaseSeed databaseSeed) async {
    final db = await _getInstance();

    await db.update(
      'seeds',
      databaseSeed.toMap(),
      where: 'id = ?',
      whereArgs: [databaseSeed.id],
    );
  }

  Future<List<DatabaseSeed>> getAll() async {
    final db = await _getInstance();

    final List<Map<String, dynamic>> maps = await db.query('seeds');

    return List.generate(maps.length, (index) =>
        DatabaseSeed.fromMap(maps[index])
    );
  }

  Future<List<DatabaseSeed>> getNonSynchronized() async {
    final db = await _getInstance();

    final List<Map<String, dynamic>> maps = await db.query(
      'seeds',
      where: 'synchronized = ?',
      whereArgs: [0],
    );

    return List.generate(maps.length, (index) =>
      DatabaseSeed.fromMap(maps[index])
    );
  }

  Future<void> clear() async {
    final db = await _getInstance();
    await db.delete('seeds');
  }

  Future<List<DatabaseSeed>> search(String query) async {
    final db = await _getInstance();

    final List<Map<String, dynamic>> maps = await db.query(
      'seeds',
      where: 'name LIKE ? or manufacturer LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return List.generate(maps.length, (index) =>
        DatabaseSeed.fromMap(maps[index])
    );
  }

}
