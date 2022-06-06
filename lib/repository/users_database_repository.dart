import 'package:seed/database/database_provider.dart';
import 'package:seed/database/user_dao.dart';
import 'package:seed/models/user.dart';
import 'package:seed/repository/users_repository.dart';
import 'package:sqflite/sqflite.dart';

class UsersDatabaseRepository implements UsersRepository {
  UsersDatabaseRepository(this.databaseProvider);

  final dao = UserDao();
  @override
  DatabaseProvider databaseProvider;

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
  Future<List<User>> getUsers() async {
    final db = await databaseProvider.db();
    List<Map<String, dynamic>> maps = await db.query(dao.tableName);
    return dao.fromList(maps);
  }

  @override
  Future<void> insert(User user) async {
    final db = await databaseProvider.db();
    await db.insert(dao.tableName, dao.toMap(user),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
