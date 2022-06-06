import 'package:seed/database/seeder_database.dart';

import '../models/user.dart';
import '../network/auth_service.dart';

class AuthRepository {
  AuthRepository(
    AuthService authService,
    SeederDatabase seederDatabase,
  )   : _authService = authService,
        _seederDatabase = seederDatabase;

  final AuthService _authService;
  final SeederDatabase _seederDatabase;

  Future<void> login(String email) async {
    final user = await _authService.login(email);
    await _seederDatabase.insertUser(user);
  }

  Future<void> signup(String fullName, String email) async {
    final user = await _authService.signup(fullName, email);
    await _seederDatabase.insertUser(user);
  }

  Future<List<User>> getUser() async {
    final userList = await _seederDatabase.getUser();
    return userList;
  }

  Future<void> delete() async {
    await _seederDatabase.clearUser();
  }
}
