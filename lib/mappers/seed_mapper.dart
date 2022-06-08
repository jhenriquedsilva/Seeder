import 'package:seed/models/database_seed.dart';
import 'package:seed/models/network_seed.dart';

import '../models/database_seed.dart';
import '../models/seed.dart';

abstract class SeedMapper {
  List<Seed> fromDatabaseToDomain(List<DatabaseSeed> databaseSeeds);
  Seed fromNetworkToDomain(NetworkSeed networkSeed);
  List<NetworkSeed> fromDatabaseToNetwork(List<DatabaseSeed> databaseSeeds);
  DatabaseSeed fromNetworkToDatabase(NetworkSeed networkSeed);
  NetworkSeed toNetwork(Seed seed);
  DatabaseSeed toDatabase(Seed seed);
}