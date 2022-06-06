import 'package:flutter/foundation.dart';

import 'package:seed/repository/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider(this._authRepository);

  final AuthRepository _authRepository;

  var isLogin = true;

  Future<bool> isAuthenticated() async {
    final userList = await _authRepository.getUser();
    return userList.isNotEmpty;
  }

  Future<void> login(String email) async {
    await _authRepository.login(email);
    notifyListeners();
  }

  Future<void> signup(String fullName, String email) async {
    await _authRepository.signup(fullName, email);
    notifyListeners();
  }

  void changeAuthMode() {
    isLogin = !isLogin;
    notifyListeners();
  }

  void _changeToLoginMode() {
    isLogin = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.delete();
    _changeToLoginMode();
  }
}
