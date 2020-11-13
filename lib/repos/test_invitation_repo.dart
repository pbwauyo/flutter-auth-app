import 'package:auth_app/models/tester.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestInvitationRepo {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _testersCollectionRef => _firestore.collection("testers");

  bool verifyInvitationCode(String invitationCode){
    final splitCode = invitationCode.split("-");
    if(splitCode.length != 2){
      return false;
    }else {
      if(double.tryParse(splitCode[0]) == null && double.tryParse(splitCode[1]) == null){
        return false;
      }
    }
    return true;
  }

  Future<Tester> getTester(String email) async{
    final querySnapshot = await _testersCollectionRef.where("email", isEqualTo: email).get();
    final doc = querySnapshot.docs.first;
    return Tester.fromMap(doc.data());
  }

  Future<bool> testerExists({@required String email, @required String invitationCode}) async{
    final querySnapshot = await _testersCollectionRef.where("email", isEqualTo: email)
                                            .where("invitationCode", isEqualTo: invitationCode).get();
    return querySnapshot.docs.first.exists;
  }

  Future<void> saveTester(Tester tester) async{
    await _testersCollectionRef.add(tester.toMap());
  }
}