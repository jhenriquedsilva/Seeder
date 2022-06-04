import 'dart:convert';

import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

import '../exceptions/email_already_exist_exception.dart';
import '../exceptions/email_does_not_exist_exception.dart';
import '../exceptions/email_not_valid_exception.dart';
import '../models/user.dart';

class AuthService {
  final _baseUrl = 'https://learning-data-sync-mobile.herokuapp.com/datasync/api';

  Future<User> login(String email) async  {

    final url = Uri.parse('$_baseUrl/user/auth');
    final response = await post(
      url,
      body: json.encode(
        {'email': email},
      ),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      }
    );

    if (response.statusCode >= 200 && response.statusCode < 300){
      return User.fromJson(json.decode(response.body));

    } else if (response.statusCode == 404) {
      throw EmailDoesNotExistException();

    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception('Dados inválidos');

    } else if (response.statusCode >= 500 && response.statusCode < 600) {
      throw Exception('Erro no servidor');

    } else {
      throw Exception(response.body);
    }

  }

  Future<User> signup(String fullName, String email) async {

    final url = Uri.parse('$_baseUrl/user');
    final id = const Uuid().v4().toString();
    final userData = {
      'id': id,
      'fullName': fullName,
      'email': email,
    };

    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    try {

      final response = await post(
        url,
        headers: headers,
        body: json.encode(userData),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return User.fromJson(userData);

      } else if (response.statusCode == 400) {
        throw EmailNotValidException();

      } else if (response.statusCode == 409) {
        throw EmailAlreadyExistException();

      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw Exception('Dados inválidos');

      } else if (response.statusCode >= 500 && response.statusCode < 600) {
        throw Exception('Erro no servidor');

      } else {
        throw Exception(response.body);

      }

    } catch (error) {
      rethrow;
    }
  }
}
