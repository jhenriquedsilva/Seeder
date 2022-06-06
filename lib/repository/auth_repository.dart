import 'package:seed/repository/users_database_repository.dart';

import '../models/user.dart';
import '../network/auth_service.dart';

class AuthRepository {
  AuthRepository(
    this._authService,
    this._usersDatabaseRepository,
  );

  final AuthService _authService;
  final UsersDatabaseRepository _usersDatabaseRepository;

  Future<void> login(String email) async {
    final user = await _authService.login(email);
    await _usersDatabaseRepository.insert(user);
  }

  Future<void> signup(String fullName, String email) async {
    final user = await _authService.signup(fullName, email);
    await _usersDatabaseRepository.insert(user);
  }

  Future<List<User>> getUser() async {
    final userList = await _usersDatabaseRepository.getUsers();
    return userList;
  }

  Future<void> delete() async {
    await _usersDatabaseRepository.clear();
  }
}
