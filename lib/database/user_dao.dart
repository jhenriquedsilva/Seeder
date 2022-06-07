import 'package:seed/database/dao.dart';
import 'package:seed/models/user.dart';
import 'package:sqflite/sqflite.dart';

import '../exceptions/db_cannot_insert_data_exception.dart';
import '../exceptions/db_does_not_clear_table_exception.dart';
import '../exceptions/db_does_not_load_data_exception.dart';
import 'database_provider.dart';

class UserDao {
  UserDao(this.databaseProvider);

  final DatabaseProvider databaseProvider;

  static const tableName = 'users';
  static const columnId = 'id';
  static const columnFullName = 'fullName';
  static const columnEmail = 'email';

  static String createTable() {
    return 'CREATE TABLE $tableName('
        '$columnId TEXT PRIMARY KEY, '
        '$columnFullName TEXT NOT NULL, '
        '$columnEmail TEXT NOT NULL'
        ')';
  }

  Future<void> insert(User user) async {
    try {
      final db = await databaseProvider.db();
      await db.insert(
        tableName,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      throw DbCannotInsertDataException();
    }
  }

  Future<List<User>> getUsers() async {
    try {
      final db = await databaseProvider.db();
      List<Map<String, dynamic>> maps = await db.query(tableName);
      return List.generate(maps.length, (index) => User.fromMap(maps[index]));
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
