import 'package:shared_preferences/shared_preferences.dart';

class PrefManager{
  static const _LOGIN_TYPE = "LOGIN_TYPE";

  static saveLoginType(String loginType) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_LOGIN_TYPE, loginType);
  }

  static Future<String> getLoginType() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(_LOGIN_TYPE);
  }

  static clearLoginType() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_LOGIN_TYPE);
  }
}