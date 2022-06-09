import 'package:flutter/foundation.dart';

import 'package:seed/repository/user_repository.dart';

class UserProvider with ChangeNotifier {
  UserProvider(this._authRepository);

  final UserRepository _authRepository;

  Future<bool> isAuthenticated() async {
    final userList = await _authRepository.getUser();
    return userList.isNotEmpty;
  }

  Future<void> signIn(String email) async {
    await _authRepository.login(email);
  }

  Future<void> signup(String fullName, String email) async {
    await _authRepository.signup(fullName, email);
  }

  Future<void> clear() async {
    await _authRepository.delete();
  }
}
