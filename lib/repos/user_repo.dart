import 'dart:io';

import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class UserRepo {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _usersCollectionRef => _firestore.collection("users");

  Future<String> uploadFile({@required String filePath, @required String folderName}) async{
    final userId = FirebaseAuth.instance.currentUser.uid;
    final file = File(filePath);
    final storageReference = FirebaseStorage.instance.ref().child("$folderName/$userId/${basename(filePath)}");
    final uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    final downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl.toString();
  }

  String getCurrentUserEmail(){
    return _firebaseAuth.currentUser.email;
  }

  Future<AppUser> getCurrentUserDetails() async{
    final username = await PrefManager.getLoginUsername();
    final docSnapshot =await _usersCollectionRef.doc(username).get();
    return AppUser.fromMap(docSnapshot.data());
  }

  Future<AppUser> getUserDetails(String username) async{
    final docSnapshot = await _usersCollectionRef.doc(username).get();
    if(docSnapshot.exists){
      return AppUser.fromMap(docSnapshot.data());
    }else {
      return AppUser();
    }
  }
}