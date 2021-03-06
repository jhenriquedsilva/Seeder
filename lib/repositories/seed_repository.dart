import 'package:intl/intl.dart';
import 'package:seed/database/seed_dao.dart';
import 'package:seed/models/seed.dart';
import 'package:uuid/uuid.dart';

import '../database/user_dao.dart';
import '../exceptions/no_non_synchronized_seeds_exception.dart';
import '../mappers/seed_mapper.dart';
import '../models/database_seed.dart';
import '../models/network_seed.dart';
import '../network/seed_http_service.dart';

class SeedRepository {
  SeedRepository(
    this._seedService,
    this._userDao,
    this._seedDao,
    this._seedMapper,
  );

  final SeedHttpService _seedService;
  final UserDao _userDao;
  final SeedDao _seedDao;
  final SeedMapper _seedMapper;

  Future<void> insert(
    Map<String, dynamic> seedData,
  ) async {

    final seedId = const Uuid().v4().toString();
    final createdAt = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(
      DateTime.now(),
    );

    final newSeed = DatabaseSeed(
      id: seedId,
      name: seedData['name'],
      manufacturer: seedData['manufacturer'],
      manufacturedAt: seedData['manufacturedAt'],
      expiresIn: seedData['expiresIn'],
      createdAt: createdAt,
      synchronized: 0,
    );

    await _seedDao.insert(newSeed);
  }

  Future<List<Seed>> cacheSeeds() async {
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

    final synchronizedDatabaseSeeds = nonSynchronizedDatabaseSeeds.map(
      (databaseSeed) => DatabaseSeed(
        id: databaseSeed.id,
        name: databaseSeed.name,
        manufacturer: databaseSeed.manufacturer,
        manufacturedAt: databaseSeed.manufacturedAt,
        expiresIn: databaseSeed.expiresIn,
        createdAt: databaseSeed.expiresIn,
        synchronized: 1,
      ),
    );

    await Future.forEach<DatabaseSeed>(
      synchronizedDatabaseSeeds,
      (databaseSeed) async {
        await _seedDao.update(databaseSeed);
      },
    );
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

  Future<void> clear() async {
    await _seedDao.clear();
  }
}
