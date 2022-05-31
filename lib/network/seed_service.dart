import 'dart:convert';

import 'package:http/http.dart';

import '../models/network_seed.dart';

class SeedService {

  final baseUrl = 'https://learning-data-sync-mobile.herokuapp.com/datasync/api/seed';

  Future<List<NetworkSeed>> fetchSeeds(String userId) async {
    final url = Uri.parse('$baseUrl/$userId');

    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        final fetchedSeeds = json.decode(response.body) as List<dynamic>;
        if (fetchedSeeds.isEmpty) {
          return [];
        }

        return fetchedSeeds.map((seedData) {
          return NetworkSeed(
            id: seedData['id'],
            name: seedData['name'],
            manufacturer:  seedData['manufacturer'],
            manufacturedAt: seedData['manufacturedAt'],
            expiresIn: seedData['expiresIn'],
            userId: seedData['userId']
          );
        }).toList();

      } else {
        throw Exception();
      }
    } catch (error) {
      rethrow;
    }
  }
}