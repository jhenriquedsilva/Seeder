import 'package:seed/database/seeder_database.dart';

import '../database/seeder_database.dart';
import '../models/database_seed.dart';
import '../models/network_seed.dart';
import '../network/seed_service.dart';

class SeedRepository {
  SeedRepository(
    SeedService seedService,
    SeederDatabase seedDatabase,
  )   : _seedService = seedService,
        _seedDatabase = seedDatabase;

  late final SeedService _seedService;
  late final SeederDatabase _seedDatabase;

  Future<List<DatabaseSeed>> getSeeds() async  {
    final networkSeeds = await _fetchRemoteSeeds();
    if (networkSeeds.isEmpty) {
      return [];
    }
    _storeSeedsOnDatabase(networkSeeds);
    return _fetchSeedsFromDatabase();
  }

  Future<List<NetworkSeed>> _fetchRemoteSeeds() async {
    return _seedService.fetchSeeds("6ab2456a-d5c5-4f05-a084-3d861fc8c02f");

  }

  Future<void> _storeSeedsOnDatabase(List<NetworkSeed> networkSeeds) async {
    await Future.forEach<NetworkSeed>(
      networkSeeds,
      (networkSeed) async {
        await _seedDatabase.insertSeed(
          DatabaseSeed(
            id: networkSeed.id,
            name: networkSeed.name,
            manufacturer: networkSeed.manufacturer,
            manufacturedAt: networkSeed.manufacturedAt,
            expiresIn: networkSeed.expiresIn,
            synchronized: 1,
          ),
        );
      },
    );
  }

  Future<List<DatabaseSeed>> _fetchSeedsFromDatabase() async {
    return _seedDatabase.getAllSeeds();
  }
}
