import 'package:intl/intl.dart';
import 'package:seed/models/seed.dart';
import 'package:seed/repository/seeds_database_repository.dart';
import 'package:seed/repository/users_database_repository.dart';
import 'package:uuid/uuid.dart';

import '../exceptions/no_non_synchronized_seeds_exception.dart';
import '../models/database_seed.dart';
import '../models/network_seed.dart';
import '../network/seed_service.dart';

class SeedRepository {
  SeedRepository(
    this._seedService,
    this._seedsDatabaseRepository,
    this._usersDatabaseRepository,
  );

  final SeedService _seedService;
  final SeedsDatabaseRepository _seedsDatabaseRepository;
  final UsersDatabaseRepository _usersDatabaseRepository;

  Future<List<DatabaseSeed>> cacheSeeds() async {
    final networkSeeds = await _fetchRemoteSeeds();
    if (networkSeeds.isEmpty) {
      return [];
    }
    await _storeSeedsOnDatabase(networkSeeds);
    return getSeeds();
  }

  Future<List<NetworkSeed>> _fetchRemoteSeeds() async {
    final users = await _usersDatabaseRepository.getUsers();
    return _seedService.fetch(users[0].id);
  }

  Future<void> _storeSeedsOnDatabase(List<NetworkSeed> networkSeeds) async {
    await Future.forEach<NetworkSeed>(
      networkSeeds,
      (networkSeed) async {
        await _seedsDatabaseRepository.insert(
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

  Future<List<DatabaseSeed>> getSeeds() async {
    return _seedsDatabaseRepository.getSeeds();
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

    await _seedsDatabaseRepository.insert(newSeed);
  }

  Future<void> synchronizeSeeds() async {
    final nonSynchronizedDatabaseSeeds =
        await _seedsDatabaseRepository.getNonSynchronizedSeeds();

    if (nonSynchronizedDatabaseSeeds.isEmpty) {
      throw NoNonSynchronizedSeedsException();
    }

    final networkSeeds = databaseSeedToNetworkSeed(
      nonSynchronizedDatabaseSeeds,
    );
    final userList = await _usersDatabaseRepository.getUsers();

    await _seedService.send(userList[0], networkSeeds);
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
        await _seedsDatabaseRepository.update(databaseSeed);
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
    await _seedsDatabaseRepository.clear();
  }

  Future<bool> areThereAnyNonSynchronized() async {
    final nonSynchronizedDatabaseSeeds =
        await _seedsDatabaseRepository.getNonSynchronizedSeeds();
    return nonSynchronizedDatabaseSeeds.isNotEmpty;
  }

  Future<List<Seed>> search(String query) async {
    final selectedDatabaseSeeds =
        await _seedsDatabaseRepository.searchSeeds(query);
    return databaseSeedToSeed(selectedDatabaseSeeds);
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
            synchronized: databaseSeed.synchronized,
          ),
        )
        .toList();
  }
}
