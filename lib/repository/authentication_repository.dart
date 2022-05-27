import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/user.dart';
import '../network/authentication_service.dart';

class AuthenticationRepository {
  AuthenticationRepository(AuthenticationService authenticationService)
      : _authenticationService = authenticationService;

  final AuthenticationService _authenticationService;

  Future<User?> login(String email) async {
    return _authenticationService.login(email);
  }

  // TODO Problems with internet connection
  Future<String?> signup(String fullName, String email) async {
    return _authenticationService.signup(fullName, email);
  }
}
