import 'package:sqflite/sqflite.dart';

import '../exceptions/db_cannot_insert_data_exception.dart';
import '../exceptions/db_does_not_clear_table_exception.dart';
import '../exceptions/db_does_not_load_data_exception.dart';
import '../models/database_seed.dart';
import 'database_provider.dart';

class SeedDao {
  SeedDao(this.databaseProvider);

  final DatabaseProvider databaseProvider;

  static const tableName = 'seeds';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnManufacturer = 'manufacturer';
  static const _columnManufacturedAt = 'manufacturedAt';
  static const _columnExpiresIn = 'expiresIn';
  static const _columnCreatedAt = 'createdAt';
  static const columnSynchronized = 'synchronized';

  static String createTable() {
    return 'CREATE TABLE seeds('
        '$columnId TEXT PRIMARY KEY, '
        '$columnName TEXT NOT NULL, '
        '$columnManufacturer TEXT NOT NULL, '
        '$_columnManufacturedAt TEXT NOT NULL, '
        '$_columnExpiresIn TEXT NOT NULL, '
        '$_columnCreatedAt TEXT NOT NULL, '
        '$columnSynchronized INTEGER NOT NULL'
        ')';
  }

  Future<void> insert(DatabaseSeed seed) async {
    try {
      final db = await databaseProvider.db();
      await db.insert(
        tableName,
        seed.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      throw DbCannotInsertDataException();
    }
  }

  Future<void> update(DatabaseSeed seed) async {
    try {
      final db = await databaseProvider.db();
      await db.update(
        tableName,
        seed.toMap(),
        where: '$columnId = ?',
        whereArgs: [seed.id],
      );
    } catch (error) {
      throw DbCannotInsertDataException();
    }
  }

  Future<List<DatabaseSeed>> getAll() async {
    try {
      final db = await databaseProvider.db();
      List<Map<String, dynamic>> maps = await db.query(
        tableName,
        orderBy: '$_columnCreatedAt DESC',
      );

      return List.generate(
          maps.length, (index) => DatabaseSeed.fromMap(maps[index]));
    } catch (error) {
      throw DbDoesNotLoadDataException();
    }
  }

  Future<List<DatabaseSeed>> getNonSynchronizedSeeds() async {
    try {
      final db = await databaseProvider.db();

      final List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: '$columnSynchronized = ?',
        whereArgs: [0],
      );

      return List.generate(
        maps.length,
        (index) => DatabaseSeed.fromMap(maps[index]),
      );
    } catch (error) {
      throw DbDoesNotLoadDataException();
    }
  }

  Future<List<DatabaseSeed>> searchSeeds(String query) async {
    try {
      final db = await databaseProvider.db();

      final List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: '$columnName LIKE ? OR $columnManufacturer LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: '$_columnCreatedAt DESC',
      );

      return List.generate(
        maps.length,
        (index) => DatabaseSeed.fromMap(maps[index]),
      );
    } catch (error) {
      throw DbDoesNotLoadDataException();
    }
  }

  Future<void> clear() async {
    try {
      final db = await databaseProvider.db();
      await db.delete(tableName);
    } catch (error) {
      throw DbDoesNotClearTableException();
    }
  }
}
