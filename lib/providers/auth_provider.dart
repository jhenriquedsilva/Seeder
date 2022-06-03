import 'package:flutter/foundation.dart';

import 'package:seed/network/authentication_service.dart';
import 'package:seed/preferences/user_shared_preferences_service.dart';
import 'package:seed/repository/authentication_repository.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider() {
    _authRepository = AuthRepository(
      AuthService(),
      UserSharedPreferencesService(),
    );
  }

  late AuthRepository _authRepository;

  var isLogin = true;

  Future<bool> isAuthenticated() async {
    final userId = await _authRepository.getId();
    return userId != null;
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

  void logout() {
    _prefs.clear();
    notifyListeners();
  }
}
