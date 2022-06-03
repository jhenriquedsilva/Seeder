class EmailAlreadyExistException implements Exception {
  @override
  String toString() {
    return 'Este email já está cadastrado';
  }
}