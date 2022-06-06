class ServerException implements Exception {
  @override
  String toString() {
    return 'Erro no servidor\nTente novamente';
  }
}