mixin Validator {
  String? validateEmail(String? email, String errorMessage) {
    final regex = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
    if (email == null || !regex.hasMatch(email)) {
      return errorMessage;
    }
    return null;
  }

  String? validateName(String? name, String errorMessage) {
    if (name == null || name.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }
}
