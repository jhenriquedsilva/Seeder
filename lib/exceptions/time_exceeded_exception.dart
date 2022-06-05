class TimeExceededException implements Exception {
  @override
  String toString() {
    return 'Erro ao carregar seus dados. Tente novamente';
  }
}