import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefManager{
  static const _LOGIN_TYPE = "LOGIN_TYPE";
  static const _TEMPORARY_DETAILS = "TEMPORARY_DETAILS";
  static const _CURRENT_USERNAME = "CURRENT_USERNAME";

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

  static saveLoginUsername(String username) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_CURRENT_USERNAME, username);
  }

  static Future<String> getLoginUsername() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(_CURRENT_USERNAME);
  }

  static clearLoginUsername() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_CURRENT_USERNAME);
  }

  static saveTemporaryUserDetails({@required String name,
  @required String username, String password = "", String photoUrl = ""}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userDetails = {
      "name" : name,
      "username" : username,
      "password" : password,
      "photoUrl" : photoUrl,
    };

    prefs.setString(_TEMPORARY_DETAILS, json.encode(userDetails));
  }

  static Future<Map<String, String>> getTemporaryUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userDetailsMap = Map<String, String>.from(json.decode(prefs.getString(_TEMPORARY_DETAILS)));
    return userDetailsMap;
  }

  static clearTemporaryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_TEMPORARY_DETAILS);
  }
}