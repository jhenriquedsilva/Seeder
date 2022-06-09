mixin Validator {
  String? validateEmail(String? email) {
    final regex = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
    if (email == null || !regex.hasMatch(email)) {
      return 'Email inválido';
    }
    return null;
  }

  String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Informe seu nome completo';
    }
    return null;
  }
}
