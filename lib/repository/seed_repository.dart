import 'package:intl/intl.dart';
import 'package:seed/database/seed_dao.dart';
import 'package:seed/models/seed.dart';
import 'package:uuid/uuid.dart';

import '../database/user_dao.dart';
import '../exceptions/no_non_synchronized_seeds_exception.dart';
import '../mappers/seed_mapper.dart';
import '../models/database_seed.dart';
import '../models/network_seed.dart';
import '../network/seed_service.dart';

class SeedRepository {
  SeedRepository(
    this._seedService,
    this._userDao,
    this._seedDao,
    this._seedMapper,
  );

  final SeedService _seedService;
  final UserDao _userDao;
  final SeedDao _seedDao;
  final SeedMapper _seedMapper;

  Future<List<DatabaseSeed>> cacheSeeds() async {
    final networkSeeds = await _fetchRemoteSeeds();
    if (networkSeeds.isEmpty) {
      return [];
    }
    await _storeSeedsOnDatabase(networkSeeds);
    final databaseSeeds = await _seedDao.getAll();
    return _seedMapper.fromDatabaseToDomain(databaseSeeds);
  }

  Future<List<NetworkSeed>> _fetchRemoteSeeds() async {
    final users = await _userDao.getUsers();
    return _seedService.fetch(users[0].id);
  }

  Future<void> _storeSeedsOnDatabase(List<NetworkSeed> networkSeeds) async {
    await Future.forEach<NetworkSeed>(
      networkSeeds,
          (networkSeed) async {
        await _seedDao.insert(_seedMapper.fromNetworkToDatabase(networkSeed));
      },
    );
  }

  Future<List<Seed>> getSeeds() async {
    final databaseSeeds = await _seedDao.getAll();
    return _seedMapper.fromDatabaseToDomain(databaseSeeds);
  }

  Future<void> synchronizeSeeds() async {
    final nonSynchronizedDatabaseSeeds =
        await _seedDao.getNonSynchronizedSeeds();

    if (nonSynchronizedDatabaseSeeds.isEmpty) {
      throw NoNonSynchronizedSeedsException();
    }

    final networkSeeds = _seedMapper.fromDatabaseToNetwork(
      nonSynchronizedDatabaseSeeds,
    );
    final userList = await _userDao.getUsers();

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
        await _seedDao.update(databaseSeed);
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
    await _seedDao.clear();
  }

  Future<bool> areThereAnyNonSynchronized() async {
    final nonSynchronizedDatabaseSeeds =
        await _seedDao.getNonSynchronizedSeeds();
    return nonSynchronizedDatabaseSeeds.isNotEmpty;
  }

  Future<List<Seed>> search(String query) async {
    final selectedDatabaseSeeds = await _seedDao.searchSeeds(query);
    return _seedMapper.fromDatabaseToDomain(selectedDatabaseSeeds);
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
