class EmailDoesNotExistException implements Exception {
  @override
  String toString() {
    return 'Este email não está cadastrado';
  }

}