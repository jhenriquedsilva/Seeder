class NoNonSynchronizedSeedsException implements Exception {
  @override
  String toString() {
    return 'Todas as sementes estão sincronizadas';
  }
}