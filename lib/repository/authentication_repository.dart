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

  Future<User> login(String email) async {
    return _authenticationService.login(email);
  }

  // TODO Problems with internet connection
  Future<User> signup(String fullName, String email) async {
    return _authenticationService.signup(fullName, email);
  }
}
