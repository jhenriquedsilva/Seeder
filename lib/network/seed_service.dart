import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:seed/exceptions/time_exceeded_exception.dart';
import 'package:seed/exceptions/unavailable_server.dart';

import '../models/network_seed.dart';
import '../models/user.dart';

class SeedService {
  final baseUrl =
      'https://learning-data-sync-mobile.herokuapp.com/datasync/api/seed';
  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  Future<List<NetworkSeed>> fetch(String userId) async {
    final url = Uri.parse('$baseUrl/$userId');

    try {
      // final response = await Future.delayed(const Duration(seconds: 5,),() => throw TimeExceededException());
      final response = await get(url).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeExceededException(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final fetchedSeeds = json.decode(response.body) as List<dynamic>;
        if (fetchedSeeds.isEmpty) {
          return [];
        }

        return fetchedSeeds.map((seedJson) {
          return NetworkSeed.fromJson(seedJson);
        }).toList();
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw Exception('Um erro ocorreu. Tente novamente');
      } else if (response.statusCode == 503) {
        throw UnavailableServerException();
      } else {
        throw Exception('Erro no servidor. Tente novamente mais tarde');
      }
    } on SocketException {
      throw Exception('Você não possui internet');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> send(User user, List<NetworkSeed> networkSeeds) async {
    final url = Uri.parse(baseUrl);

    try {
      await Future.forEach<NetworkSeed>(
        networkSeeds,
        (networkSeed) async {
          final response = await post(
            url,
            body: networkSeed.toJson(user.id),
            headers: headers,
          ).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeExceededException(),
          );

          if (response.statusCode >= 400 && response.statusCode < 500) {
            throw Exception('Um erro ocorreu. Tente novamente');
          } else if (response.statusCode == 503) {
            throw UnavailableServerException();
          } else {
            throw Exception('Erro no servidor. Tente novamente mais tarde');
          }
        },
      );
    } on SocketException {
      throw Exception('Você não possui internet');
    } catch (error) {
      rethrow;
    }
  }
}
