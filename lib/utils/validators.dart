import 'package:regexed_validator/regexed_validator.dart';

class Validators {
  static bool validatePhoneNumber(String phoneNumber) {
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
  // static bool validatePassword(){
  //   validator.mediumPassword(input)
  // }
}