import 'package:seed/database/database_provider.dart';

import '../models/user.dart';

abstract class UsersRepository {
  late DatabaseProvider databaseProvider;

  Future<void> insert(User user);

  Future<List<User>> getUsers();

  Future<void> clear();
}