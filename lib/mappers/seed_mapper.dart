import 'package:seed/models/database_seed.dart';
import 'package:seed/models/network_seed.dart';

import '../models/database_seed.dart';
import '../models/seed.dart';

abstract class SeedMapper {
  Seed fromDatabaseToDomain(DatabaseSeed databaseSeed);
  Seed fromNetworkToDomain(NetworkSeed networkSeed);
  DatabaseSeed fromNetworkToDatabase(NetworkSeed networkSeed);
  NetworkSeed toNetwork(Seed seed);
  DatabaseSeed toDatabase(Seed seed);
}