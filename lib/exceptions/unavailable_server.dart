class UnavailableServerException implements Exception {
  @override
  String toString() {
    return 'Servidor indisponível. Tente novamente mais tarde';
  }
}