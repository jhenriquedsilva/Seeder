import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:seed/repository/seed_repository.dart';

import '../models/seed.dart';

class SeedProvider with ChangeNotifier {
  SeedProvider(this._seedRepository);

  final SeedRepository _seedRepository;
  late List<Seed> allSeeds;

  Future<void> insert(
    String seedName,
    String manufacturerName,
    DateTime manufacturedAt,
    DateTime expiresIn,
  ) async {
    final seedData = {
      'name': seedName,
      'manufacturer': manufacturerName,
      'manufacturedAt': DateFormat('yyyy-MM-dd').format(
        manufacturedAt,
      ),
      'expiresIn': DateFormat('yyyy-MM-dd').format(
        expiresIn,
      ),
    };

    await _seedRepository.insert(seedData);
  }

  Future<void> cacheSeeds() async {
    final seeds = await _seedRepository.cacheSeeds();
    if (seeds.isEmpty) {
      allSeeds = [];
      notifyListeners();
      return;
    }
    allSeeds = seeds;
  }

  Future<void> getSeeds() async {
    final seeds = await _seedRepository.getSeeds();
    if (seeds.isEmpty) {
      allSeeds = [];
      notifyListeners();
      return;
    }
    allSeeds = seeds;
    notifyListeners();
  }

  Future<void> synchronize() async {
    await _seedRepository.synchronizeSeeds();
    await getSeeds();
  }

  Future<bool> areThereAnyNonSynchronized() async {
    return _seedRepository.areThereAnyNonSynchronized();
  }

  Future<void> searchSeeds(String query) async {
    final selectedSeeds = await _seedRepository.search(query);
    allSeeds = selectedSeeds;
    notifyListeners();
  }

  Future<void> clear() async {
    await _seedRepository.clear();
  }
}
