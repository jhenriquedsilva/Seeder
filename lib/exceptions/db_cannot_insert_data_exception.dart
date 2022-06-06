class DbCannotInsertDataException implements Exception {
  @override
  String toString() {
    return 'Erro ao salvar dados.\nTente novamente';
  }
}