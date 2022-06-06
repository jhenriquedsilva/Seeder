class EmailNotValidException implements Exception {
  @override
  String toString() {
    return 'Email inválido';
  }
}