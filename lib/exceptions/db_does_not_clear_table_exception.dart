class DbDoesNotClearTableException implements Exception {
  @override
  String toString() {
    return 'Ocorreu um erro ao sair.\nTente novamente';
  }
}