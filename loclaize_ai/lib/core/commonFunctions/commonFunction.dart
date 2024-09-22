bool isValidEmail(String email) {
  String emailPattern =
      r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$';

  RegExp regExp = RegExp(emailPattern);

  return regExp.hasMatch(email);
}
