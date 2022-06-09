import 'dart:convert';
import 'package:http/http.dart';
import 'package:seed/network/http_sevice.dart';
import 'package:uuid/uuid.dart';

import '../exceptions/time_exceeded_exception.dart';
import '../models/user.dart';

class AuthService extends HttpService {
  Future<User> login(String email) async {
    try {
      const endpoint = '/user/auth';
      await verifyInternetConnection();

      final url = Uri.parse(baseUrl + endpoint);
      final response = await post(url,
              body: json.encode(
                {'email': email},
              ),
              headers: headers)
          .timeout(
        timeoutDuration,
        onTimeout: () => throw TimeExceededException(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return User.fromMap(json.decode(response.body));
      } else {
        throw createAppropriateException(response.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<User> signup(String fullName, String email) async {
    try {
      const endpoint = '/user';
      await verifyInternetConnection();

      final url = Uri.parse(baseUrl + endpoint);
      final id = const Uuid().v4().toString();
      final user = {
        'id': id,
        'fullName': fullName,
        'email': email,
      };

      final response = await post(
        url,
        headers: headers,
        body: json.encode(user),
      ).timeout(
        timeoutDuration,
        onTimeout: () => throw TimeExceededException(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return User.fromMap(user);
      } else {
        throw createAppropriateException(response.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }
}
