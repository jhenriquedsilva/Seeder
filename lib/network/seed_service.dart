import 'dart:convert';

import 'package:http/http.dart';
import 'package:seed/preferences/local_storage_service.dart';

import '../models/network_seed.dart';

class SeedService {
  SeedService(LocalStorageService localStorageService)
      : _localStorageService = localStorageService;

  final LocalStorageService _localStorageService;
  final baseUrl =
      'https://learning-data-sync-mobile.herokuapp.com/datasync/api/seed';
  static const USER_ID = 'user_id';
  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  Future<List<NetworkSeed>> fetch(String userId) async {
    final url = Uri.parse('$baseUrl/$userId');

    try {
      final response = await get(url);

      if (response.statusCode == 200) {
        final fetchedSeeds = json.decode(response.body) as List<dynamic>;
        if (fetchedSeeds.isEmpty) {
          return [];
        }

        return fetchedSeeds.map((seedJson) {
          return NetworkSeed.fromJson(seedJson);
        }).toList();
      } else {
        throw Exception();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> send(List<NetworkSeed> networkSeeds) async {
    final url = Uri.parse(baseUrl);
    final userId = await _localStorageService.getId() as String;

    try {
      await Future.forEach<NetworkSeed>(
        networkSeeds,
        (networkSeed) async {
          final response = await post(
            url,
            body: networkSeed.toJson(userId),
            headers: headers,
          );

          if (response.statusCode >= 400 && response.statusCode < 500) {
            throw Exception('${response.body}');
          } else if (response.statusCode >= 500 && response.statusCode < 600) {
            throw Exception('${response.body}');
          }
        },
      );
    } catch (error) {
      rethrow;
    }
  }
}
