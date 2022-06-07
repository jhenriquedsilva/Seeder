import 'package:seed/mappers/seed_mapper.dart';
import 'package:seed/models/database_seed.dart';
import 'package:seed/models/network_seed.dart';
import 'package:seed/models/seed.dart';

class StandardSeedMapper implements SeedMapper {
  @override
  Seed fromDatabaseToDomain(DatabaseSeed databaseSeed) {
    // TODO: implement fromDatabaseToDomain
    throw UnimplementedError();
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