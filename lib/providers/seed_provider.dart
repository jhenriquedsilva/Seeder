import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:seed/repository/seed_repository.dart';

import '../models/database_seed.dart';
import '../models/seed.dart';

class SeedProvider with ChangeNotifier {
  SeedProvider(this._seedRepository);

  final SeedRepository _seedRepository;
  late List<Seed> allSeeds;

  Future<void> insert(
      String seedName,
      String manufacturerName,
      DateTime manufacturedAt,
      DateTime expiresIn,
      ) async {
    final seedData = {
      'name': seedName,
      'manufacturer': manufacturerName,
      'manufacturedAt': DateFormat('yyyy-MM-dd').format(
        manufacturedAt,
      ),
      'expiresIn': DateFormat('yyyy-MM-dd').format(
        expiresIn,
      ),
    };

    await _seedRepository.insert(seedData);
  }

  Future<void> cacheSeeds() async {
    final databaseSeeds = await _seedRepository.cacheSeeds();
    if (databaseSeeds.isEmpty) {
      allSeeds = [];
      notifyListeners();
      return;
    }
    final seeds = databaseSeedToSeed(databaseSeeds);
    seeds.sort((firstSeed, secondSeed) {
      return firstSeed.createdAt.compareTo(secondSeed.createdAt);
    });
    allSeeds = seeds.reversed.toList();
  }

  Future<void> getSeeds() async {
    final databaseSeeds = await _seedRepository.getSeeds();
    if (databaseSeeds.isEmpty) {
      allSeeds = [];
      notifyListeners();
      return;
    }
    final seeds = databaseSeedToSeed(databaseSeeds);
    seeds.sort((firstSeed, secondSeed) {
      return firstSeed.createdAt.compareTo(secondSeed.createdAt);
    });
    allSeeds = seeds.reversed.toList();

    notifyListeners();
  }

  List<Seed> databaseSeedToSeed(List<DatabaseSeed> databaseSeeds) {
    return databaseSeeds
        .map(
          (databaseSeed) => Seed(
              id: databaseSeed.id,
              name: databaseSeed.name,
              manufacturer: databaseSeed.manufacturer,
              manufacturedAt: DateTime.parse(databaseSeed.manufacturedAt),
              expiresIn: DateTime.parse(databaseSeed.expiresIn),
              createdAt: DateTime.parse(databaseSeed.createdAt),
              synchronized: databaseSeed.synchronized),
        )
        .toList();
  }

  Future<void> insert(
    String seedName,
    String manufacturerName,
    DateTime manufacturedAt,
    DateTime expiresIn,
  ) async {
    await _seedRepository.insert(
      seedName,
      manufacturerName,
      manufacturedAt,
      expiresIn,
    );
  }

  Future<void> synchronize() async {
    await _seedRepository.synchronizeSeeds();
    await getSeeds();
  }

  Future<void> clear() async {
    await _seedRepository.clear();
  }

  Future<bool> areThereAnyNonSynchronized() async {
    return _seedRepository.areThereAnyNonSynchronized();
  }

  Future<void> searchSeeds(String query) async {
    final selectedSeeds = await _seedRepository.search(query);
    selectedSeeds.sort((firstSeed, secondSeed) {
      return firstSeed.createdAt.compareTo(secondSeed.createdAt);
    });
    allSeeds = selectedSeeds.reversed.toList();
    notifyListeners();
  }
}
