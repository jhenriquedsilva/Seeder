import 'package:flutter/foundation.dart';
import 'package:seed/database/seeder_database.dart';
import 'package:seed/network/seed_service.dart';
import 'package:seed/repository/seed_repository.dart';

import '../models/database_seed.dart';
import '../models/seed.dart';

class SeedProvider with ChangeNotifier {
  SeedProvider() {
    _seedRepository = SeedRepository(
      SeedService(),
      SeederDatabase(),
    );
  }

  late final SeedRepository _seedRepository;
  late List<Seed> seeds;

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
          ),
        )
        .toList();
  }
}