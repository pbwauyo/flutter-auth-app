class Validators {
  static bool isValidPhoneNumber(String phoneNumber) {
    final pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (phoneNumber == null || phoneNumber.isEmpty) {
      return false;
    }

    if (!regExp.hasMatch(phoneNumber)) {
      return false;
    }
    return true;
  }
}