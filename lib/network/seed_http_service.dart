import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:seed/exceptions/time_exceeded_exception.dart';
import 'package:seed/network/http_sevice.dart';

import '../models/network_seed.dart';
import '../models/user.dart';

class SeedHttpService extends HttpService {
  Future<List<NetworkSeed>> fetch(String userId) async {
    try {
      final endpoint = '/seed/$userId';
      await verifyInternetConnection();

      final url = Uri.parse(baseUrl + endpoint);
      final response = await get(url).timeout(
        timeoutDuration,
        onTimeout: () => throw TimeExceededException(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final fetchedSeeds = json.decode(response.body) as List<dynamic>;
        if (fetchedSeeds.isEmpty) {
          return [];
        }

        return fetchedSeeds
            .map((seedJson) => NetworkSeed.fromJson(seedJson))
            .toList();
      } else {
        throw createAppropriateException(response.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> send(User user, List<NetworkSeed> networkSeeds) async {
    try {
      const endpoint = '/seed';
      await verifyInternetConnection();

      final url = Uri.parse(baseUrl + endpoint);
      await Future.forEach<NetworkSeed>(
        networkSeeds,
        (networkSeed) async {
          final response = await post(
            url,
            body: networkSeed.toJson(user.id),
            headers: headers,
          ).timeout(
            timeoutDuration,
            onTimeout: () => throw TimeExceededException(),
          );

          if (response.statusCode < 200 || response.statusCode >= 300) {
            throw createAppropriateException(response.statusCode);
          }
        },
      );
    } catch (error) {
      rethrow;
    }
  }
}
