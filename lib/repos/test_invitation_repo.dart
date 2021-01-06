import 'package:auth_app/models/tester.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestInvitationRepo {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _testersCollectionRef => _firestore.collection("testers");
  CollectionReference get _invitationCodesCollectionRef => _firestore.collection("invitation_codes");
  CollectionReference get _pendingTestersCollectionRef => _firestore.collection("pending_testers");

  // bool verifyInvitationCode(String invitationCode){
  //   final splitCode = invitationCode.split("-");
  //   if(splitCode.length != 2){
  //     return false;
  //   }else {
  //     if(double.tryParse(splitCode[0]) == null && double.tryParse(splitCode[1]) == null){
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  bool verifyInvitationCodeWithOutHyphene(String invitationCode){
    if(invitationCode.length < 7){
      return false;
    }
    else if(double.tryParse(invitationCode) == null) { 
      return false;
    }
    return true;
  }

  // Future<Tester> getTester(String email) async{
  //   final querySnapshot = await _testersCollectionRef.where("email", isEqualTo: email).get();
  //   final doc = querySnapshot.docs.first;
  //   return Tester.fromMap(doc.data());
  // }

  // Future<String> getInvitationCode() async{
  //   final querySnapshot = await _invitationCodesCollectionRef.where("used", isEqualTo: "false").get();
  //   final docs = querySnapshot.docs;
  //   if(docs.length > 0){
  //     final code = docs.first.data()["code"];
  //     return code;
  //   }else{
  //     return "";
  //   }
  // }

  // Future<bool> testerExists({@required String email, @required String invitationCode}) async{
  //   final querySnapshot = await _testersCollectionRef.where("email", isEqualTo: email)
  //                                           .where("invitationCode", isEqualTo: invitationCode).get();
  //   return querySnapshot.docs.first.exists;
  // }

  Future<void> saveTester(Tester tester) async{
    final doc = await _testersCollectionRef.doc(tester.email).get();
    if(doc.exists){
      throw("Profile already exists");
    }else{
      await _testersCollectionRef.doc(tester.email).set(tester.toMap());
    }
  }

  Future<void> loginTester({@required String email, @required String invitationCode}) async{
    final testerDoc = await _testersCollectionRef.doc(email).get();
    if(testerDoc.exists){
      final tester = Tester.fromMap(testerDoc.data());

      if(tester.invitationCode.isNotEmpty){ //if theres an invitation code already
        if(tester.invitationCode != invitationCode){
          throw("Invalid invitation code");
        }
      }else{
        final codesQuerySnapshot = await _invitationCodesCollectionRef.where("code", isEqualTo: invitationCode)
                                                                      .where("used", isEqualTo: "false").get();
        if(codesQuerySnapshot.docs.length <= 0){ //if code doesn't exist or is used
          throw("No matching invitation code");
        }

        final doc = codesQuerySnapshot.docs.first;
        await doc.reference.set({"used" : "true"}, SetOptions(merge: true));
        await testerDoc.reference.set({"invitationCode" : invitationCode}, SetOptions(merge: true));
      }
    }else{
      throw("No matching profile");
    }
  }
  
}