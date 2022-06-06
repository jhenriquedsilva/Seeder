import '../database/database_provider.dart';
import '../models/seed.dart';

abstract class SeedsRepository {
  late DatabaseProvider databaseProvider;

  Future<void> insert(Seed seed);

  Future<void> update(Seed seed);

  Future<void> clear(Seed seed);

  Future<List<Seed>> getSeeds();

  Future<List<Seed>> getNonSynchronizedSeeds();

  Future<List<Seed>> searchSeeds(String query);
}