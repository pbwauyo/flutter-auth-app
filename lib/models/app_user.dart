import 'package:flutter/foundation.dart';

class AppUser {
  String username;
  String name;
  String photoUrl;

  AppUser({this.username, this.name, this.photoUrl});

  Map<String, String> toMap(){
    return {
      "username" : username ?? "",
      "firstName" : name ?? "",
      "photoUrl" : photoUrl ?? "",
     };
  }

 factory AppUser.fromMap(Map<String, dynamic> map){
    return AppUser(
      username: map["username"],
      name: map["firstName"],
      photoUrl: map["photoUrl"],
    );
  }

}