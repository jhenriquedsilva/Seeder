mixin Validator {
  bool isNameNotValid(String? name) {
    return name == null || name.trim().isEmpty;
  }

  bool isEmailNotValid(String? email) {
    return email == null ||
        !RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$')
            .hasMatch(email);
  }
}
