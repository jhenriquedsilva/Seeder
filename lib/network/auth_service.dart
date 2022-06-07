import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:seed/exceptions/no_internet_exception.dart';
import 'package:seed/exceptions/server_exception.dart';
import 'package:uuid/uuid.dart';

import '../exceptions/email_already_exist_exception.dart';
import '../exceptions/email_does_not_exist_exception.dart';
import '../exceptions/email_not_valid_exception.dart';
import '../exceptions/local_exception.dart';
import '../exceptions/time_exceeded_exception.dart';
import '../exceptions/unavailable_server.dart';
import '../models/user.dart';

class AuthService {
  final _baseUrl = 'https://learning-data-sync-mobile.herokuapp.com/datasync/api';
  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  Future<User> login(String email) async  {

    try {

      final url = Uri.parse('$_baseUrl/user/auth');
      final response = await post(
          url,
          body: json.encode(
            {'email': email},
          ),
          headers: headers
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeExceededException(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300){
        return User.fromMap(json.decode(response.body));

      } else if (response.statusCode == 404) {
        throw EmailDoesNotExistException();

      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw LocalException();

      } else if (response.statusCode == 503) {
        throw UnavailableServerException();

      } else {
        throw ServerException();
      }

    } on SocketException {
      throw NoInternetException();

    } catch (error) {
      rethrow;
    }

}

  Future<User> signup(String fullName, String email) async {

    final url = Uri.parse('$_baseUrl/user');
    final id = const Uuid().v4().toString();
    final user = {
      'id': id,
      'fullName': fullName,
      'email': email,
    };

    try {

      final response = await post(
        url,
        headers: headers,
        body: json.encode(user),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeExceededException(),
      );
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return User.fromMap(user);

      } else if (response.statusCode == 400) {
        throw EmailNotValidException();

      } else if (response.statusCode == 409) {
        throw EmailAlreadyExistException();

      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw LocalException();

      } else if (response.statusCode == 503) {
        throw UnavailableServerException();

      } else {
        throw ServerException();
      }

    } on SocketException {
      throw NoInternetException();

    } catch (error) {
      rethrow;
    }

  }
}
