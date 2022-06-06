import '../database/database_provider.dart';
import '../models/database_seed.dart';

abstract class SeedsRepository {
  late DatabaseProvider databaseProvider;

  Future<void> insert(DatabaseSeed seed);

  Future<void> update(DatabaseSeed seed);

  Future<void> clear();

  Future<List<DatabaseSeed>> getSeeds();

  Future<List<DatabaseSeed>> getNonSynchronizedSeeds();

  Future<List<DatabaseSeed>> searchSeeds(String query);
}