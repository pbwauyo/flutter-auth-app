import 'package:get/get.dart';

class LoggedInUsernameController extends GetxController {
  String _loggedInUsername;

  String get loggedInUserEmail => _loggedInUsername;

  set loggedInUserEmail(String username){
    _loggedInUsername = username;
    update();
  }

}