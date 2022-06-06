import 'package:intl/intl.dart';
import 'package:seed/database/seeder_database.dart';
import 'package:seed/models/seed.dart';
import 'package:uuid/uuid.dart';

import '../database/seeder_database.dart';
import '../exceptions/no_non_synchronized_seeds_exception.dart';
import '../models/database_seed.dart';
import '../models/network_seed.dart';
import '../network/seed_service.dart';

class SeedRepository {
  SeedRepository(
    SeedService seedService,
    SeederDatabase seedDatabase,
  )   : _seedService = seedService,
        _seederDatabase = seedDatabase;

  late final SeedService _seedService;
  late final SeederDatabase _seederDatabase;

  Future<List<DatabaseSeed>> cacheSeeds() async {
    final networkSeeds = await _fetchRemoteSeeds();
    if (networkSeeds.isEmpty) {
      return [];
    }
    await _storeSeedsOnDatabase(networkSeeds);
    return _fetchSeedsFromDatabase();
  }

  Future<List<NetworkSeed>> _fetchRemoteSeeds() async {
    return _seedService.fetch();
  }

  Future<void> _storeSeedsOnDatabase(List<NetworkSeed> networkSeeds) async {
    await Future.forEach<NetworkSeed>(
      networkSeeds,
      (networkSeed) async {
        await _seederDatabase.insertSeed(
          DatabaseSeed(
            id: networkSeed.id,
            name: networkSeed.name,
            manufacturer: networkSeed.manufacturer,
            manufacturedAt: networkSeed.manufacturedAt,
            expiresIn: networkSeed.expiresIn,
            createdAt: networkSeed.createdAt,
            synchronized: 1,
          ),
        );
      },
    );
  }

  Future<List<DatabaseSeed>> _fetchSeedsFromDatabase() async {
    return _seederDatabase.getAllSeeds();
  }

  Future<List<DatabaseSeed>> getSeeds() async {
    return _seederDatabase.getAllSeeds();
  }

  Future<void> insert(
    String seedName,
    String manufacturerName,
    DateTime manufacturedAt,
    DateTime expiresIn,
  ) async {
    final seedId = const Uuid().v4().toString();
    final createdAt =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
    final manufactured = DateFormat('yyyy-MM-dd').format(manufacturedAt);
    final expired = DateFormat('yyyy-MM-dd').format(expiresIn);
    final newSeed = DatabaseSeed(
      id: seedId,
      name: seedName,
      manufacturer: manufacturerName,
      manufacturedAt: manufactured,
      expiresIn: expired,
      createdAt: createdAt,
      synchronized: 0,
    );

    await _seederDatabase.insertSeed(newSeed);
  }

  Future<void> synchronizeSeeds() async {
    final nonSynchronizedDatabaseSeeds =
        await _seederDatabase.getNonSynchronizedSeeds();

    if (nonSynchronizedDatabaseSeeds.isEmpty) {
      throw NoNonSynchronizedSeedsException();
    }

    await _seedService
        .send(databaseSeedToNetworkSeed(nonSynchronizedDatabaseSeeds));
    final synchronizedDatabaseSeeds =
        nonSynchronizedDatabaseSeeds.map((databaseSeed) => DatabaseSeed(
              id: databaseSeed.id,
              name: databaseSeed.name,
              manufacturer: databaseSeed.manufacturer,
              manufacturedAt: databaseSeed.manufacturedAt,
              expiresIn: databaseSeed.expiresIn,
              createdAt: databaseSeed.expiresIn,
              synchronized: 1,
            ));

    await Future.forEach<DatabaseSeed>(
      synchronizedDatabaseSeeds,
      (databaseSeed) async {
        await _seederDatabase.updateSeed(databaseSeed);
      },
    );
  }

  List<NetworkSeed> databaseSeedToNetworkSeed(
      List<DatabaseSeed> databaseSeeds) {
    return databaseSeeds
        .map(
          (databaseSeed) => NetworkSeed(
            id: databaseSeed.id,
            name: databaseSeed.name,
            manufacturer: databaseSeed.manufacturer,
            manufacturedAt: databaseSeed.manufacturedAt,
            createdAt: databaseSeed.createdAt,
            expiresIn: databaseSeed.expiresIn,
          ),
        )
        .toList();
  }

  Future<void> clear() async {
    await _seederDatabase.clearSeeds();
  }

  Future<bool> areThereAnyNonSynchronized() async {
    final nonSynchronizedDatabaseSeeds = await _seederDatabase.getNonSynchronizedSeeds();
    return nonSynchronizedDatabaseSeeds.isNotEmpty;
  }

  Future<List<Seed>> search(String query) async {
    final selectedDatabaseSeeds = await _seederDatabase.searchSeeds(query);
    return databaseSeedToSeed(selectedDatabaseSeeds);
  }

  List<Seed> databaseSeedToSeed(List<DatabaseSeed> databaseSeeds) {
    return databaseSeeds
        .map(
          (databaseSeed) => Seed(
            id: databaseSeed.id,
            name: databaseSeed.name,
            manufacturer: databaseSeed.manufacturer,
            manufacturedAt: DateTime.parse(
                databaseSeed.manufacturedAt),
            expiresIn: DateTime.parse(
                databaseSeed.expiresIn),
            createdAt: DateTime.parse(databaseSeed.createdAt),
            synchronized: databaseSeed.synchronized,
          ),
        )
        .toList();
  }
}
