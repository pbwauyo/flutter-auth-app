import 'package:flutter/foundation.dart';

class AppUser {
  String username;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String photoUrl;

  AppUser({this.username, this.email, this.firstName, this.lastName, this.phoneNumber, this.photoUrl});

  Map<String, String> toMap(){
    return {
      "username" : username ?? "",
      "email" : email ?? "",
      "firstName" : firstName ?? "",
      "lastName" : lastName ?? "",
      "phoneNumber" : phoneNumber ?? "",
      "photoUrl" : photoUrl ?? "",
     };
  }

 factory AppUser.fromMap(Map<String, dynamic> map){
    return AppUser(
      username: map["username"],
      email: map["email"],
      firstName: map["firstName"],
      lastName: map["lastName"],
      phoneNumber: map["phoneNumber"],
      photoUrl: map["photoUrl"],
    );
  }

}