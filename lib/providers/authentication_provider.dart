import 'package:flutter/foundation.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seed/models/user.dart';
import 'package:seed/network/authentication_service.dart';
import 'package:seed/repository/authentication_repository.dart';

class AuthenticationProvider with ChangeNotifier {

  AuthenticationProvider() {
    _authenticationService = AuthenticationService();
    _authenticationRepository =
        AuthenticationRepository(_authenticationService);
  }

  late var _authenticationService = AuthenticationService();
  late var _authenticationRepository =
      AuthenticationRepository(_authenticationService);
  var isLogin = true;

  Future<User?> login(String email) {
    return _authenticationRepository.login(email);

  }

  Future<String?> signup(String fullName, String email) {
    return _authenticationRepository.signup(fullName, email);
  }

  void changeAuthMode() {
    isLogin = !isLogin;
    notifyListeners();
  }
}
