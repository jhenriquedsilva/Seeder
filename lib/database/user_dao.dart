import 'package:seed/database/dao.dart';
import 'package:seed/models/user.dart';

class UserDao implements Dao<User> {
  final tableName = 'users';
  final columnId = 'id';
  final columnFullName = 'fullName';
  final columnEmail = 'email';

  @override
  String get createTableQuery => 'CREATE TABLE $tableName('
      '$columnId TEXT PRIMARY KEY, '
      '$columnFullName TEXT NOT NULL, '
      '$columnEmail TEXT NOT NULL'
      ')';

  @override
  List<User> fromList(List<Map<String, dynamic>> query) {
    List<User> users = [];
    for (Map<String, dynamic> map in query) {
      users.add(fromMap(map));
    }
    return users;
  }

  @override
  User fromMap(Map<String, dynamic> query) {
    return User(
      id: query[columnId],
      fullName: query[columnFullName],
      email: query[columnEmail],
    );
  }

  @override
  Map<String, dynamic> toMap(User user) {
    return <String, dynamic>{
      columnId: user.id,
      columnFullName: user.fullName,
      columnEmail: user.email
    };
  }
}
