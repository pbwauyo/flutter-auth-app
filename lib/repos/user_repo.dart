import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class UserRepo {
  final _firebaseAuth = FirebaseAuth.instance;

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
}