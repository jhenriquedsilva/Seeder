import 'package:flutter/foundation.dart';
import 'package:seed/database/seeder_database.dart';
import 'package:seed/network/seed_service.dart';
import 'package:seed/preferences/user_shared_preferences_service.dart';
import 'package:seed/repository/seed_repository.dart';

import '../models/database_seed.dart';
import '../models/seed.dart';

class SeedProvider with ChangeNotifier {
  SeedProvider() {
    _seedRepository = SeedRepository(
      SeedService(
        UserSharedPreferencesService(),
      ),
      SeederDatabase(),
    );
  }

  late SeedRepository _seedRepository;
  late List<Seed> seeds;

  Future<void> cacheSeeds() async {
    final databaseSeeds = await _seedRepository.cacheSeeds();
    if (databaseSeeds.isEmpty) {
      seeds = [];
      notifyListeners();
      return;
    }
    seeds = databaseSeedToSeed(databaseSeeds);
  }

  Future<void> getSeeds() async {
    final databaseSeeds = await _seedRepository.getSeeds();
    if (databaseSeeds.isEmpty) {
      seeds = [];
      notifyListeners();
      return;
    }
    seeds = databaseSeedToSeed(databaseSeeds);
  }

  List<Seed> databaseSeedToSeed(List<DatabaseSeed> databaseSeeds) {
    return databaseSeeds
        .map(
          (databaseSeed) => Seed(
              name: databaseSeed.name,
              manufacturer: databaseSeed.manufacturer,
              manufacturedAt: databaseSeed.manufacturedAt,
              expiresIn: databaseSeed.expiresIn,
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
}
