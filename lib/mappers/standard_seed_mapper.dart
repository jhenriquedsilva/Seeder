import 'package:seed/mappers/seed_mapper.dart';
import 'package:seed/models/database_seed.dart';
import 'package:seed/models/network_seed.dart';
import 'package:seed/models/seed.dart';

class StandardSeedMapper implements SeedMapper {
  @override
  List<Seed> fromDatabaseToDomain(List<DatabaseSeed> databaseSeeds) {
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

  @override
  List<NetworkSeed> fromDatabaseToNetwork(List<DatabaseSeed> databaseSeeds) {
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

  @override
  DatabaseSeed fromNetworkToDatabase(NetworkSeed networkSeed) {
    return DatabaseSeed(
      id: networkSeed.id,
      name: networkSeed.name,
      manufacturer: networkSeed.manufacturer,
      manufacturedAt: networkSeed.manufacturedAt,
      expiresIn: networkSeed.expiresIn,
      createdAt: networkSeed.createdAt,
      synchronized: 1,
    );
  }

  @override
  Seed fromNetworkToDomain(NetworkSeed networkSeed) {
    // TODO: implement fromNetworkToDomain
    throw UnimplementedError();
  }

  @override
  DatabaseSeed toDatabase(Seed seed) {
    // TODO: implement toDatabase
    throw UnimplementedError();
  }

  @override
  NetworkSeed toNetwork(Seed seed) {
    // TODO: implement toNetwork
    throw UnimplementedError();
  }
}
