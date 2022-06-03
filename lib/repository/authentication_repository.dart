import 'package:seed/preferences/local_storage_service.dart';

import '../network/authentication_service.dart';

class AuthRepository {
  AuthRepository(
    AuthService authService,
    LocalStorageService localStorageService,
  )   : _authService = authService,
        _localStorageService = localStorageService;

  final AuthService _authService;
  final LocalStorageService _localStorageService;

  Future<void> login(String email) async {
    final user = await _authService.login(email);
    await _localStorageService.save(user);
  }

  Future<void> signup(String fullName, String email) async {
    final user = await _authService.signup(fullName, email);
    _localStorageService.save(user);
  }

  Future<String?> getId() async {
    final userId = await _localStorageService.getId();
    return userId;
  }

  Future<void> delete() async {
    await _localStorageService.delete();
  }
}
