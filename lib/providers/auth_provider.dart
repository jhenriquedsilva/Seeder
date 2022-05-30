import 'package:flutter/foundation.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seed/models/user.dart';
import 'package:seed/network/authentication_service.dart';
import 'package:seed/repository/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {

  AuthProvider() {
    _authenticationService = AuthenticationService();
    _authenticationRepository =
        AuthenticationRepository(_authenticationService);
  }

  late var _authenticationService = AuthenticationService();
  late var _authenticationRepository =
      AuthenticationRepository(_authenticationService);




  static const USER_ID = 'user_id';
  var isLogin = true;
  late SharedPreferences _prefs;

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    final userId = prefs.getString(USER_ID);
    return  userId != null;
  }

  Future<void> login(String email) async {
    final user = await _authenticationRepository.login(email);
    _prefs.setString(USER_ID, user.id);
    notifyListeners();
  }

  Future<void> signup(String fullName, String email) async {
    final user = await _authenticationRepository.signup(fullName, email);
    _prefs.setString(USER_ID, user.id);
    notifyListeners();
  }

  void changeAuthMode() {
    isLogin = !isLogin;
    notifyListeners();
  }
}
