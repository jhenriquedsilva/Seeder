class UnavailableServerException implements Exception {
  @override
  String toString() {
    return 'Servidor indisponível\nTente novamente mais tarde';
  }
}