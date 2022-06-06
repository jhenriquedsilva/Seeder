class DbDoesNotLoadDataException implements Exception {
  @override
  String toString() {
    return 'Erro ao carregar os dados.\nTente novamente';
  }
}