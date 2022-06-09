import 'dart:io';

import 'package:seed/exceptions/server_exception.dart';

import '../exceptions/email_already_exist_exception.dart';
import '../exceptions/email_does_not_exist_exception.dart';
import '../exceptions/email_not_valid_exception.dart';
import '../exceptions/local_exception.dart';
import '../exceptions/no_internet_exception.dart';
import '../exceptions/unavailable_server.dart';

class HttpService {
  final baseUrl =
      'https://learning-data-sync-mobile.herokuapp.com/datasync/api';
  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };
  final timeoutDuration = const Duration(seconds: 30);

  Future<void> verifyInternetConnection() async {
    try {
      await InternetAddress.lookup('www.google.com');
    } on SocketException {
      throw NoInternetException();
    }
  }

  Exception createAppropriateException(int statusCode) {
    if (statusCode == 400) {
      return EmailNotValidException();
    } else if (statusCode == 404) {
      return EmailDoesNotExistException();
    } else if (statusCode == 409) {
      return EmailAlreadyExistException();
    } else if (statusCode == 503) {
      return UnavailableServerException();
    } else if (statusCode >= 400 && statusCode < 500) {
      return LocalException();
    } else {
      return ServerException();
    }
  }
}
