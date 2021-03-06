import 'package:auth_app/getxcontrollers/logged_in_username.dart';
import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class HapprContactRepo {
  final _firestore = FirebaseFirestore.instance;
  CollectionReference get _happrContactCollectionsRef => _firestore.collection("happr_contacts");
  final LoggedInUsernameController _loggedInUsernameController = Get.find();

  Future<void> postHapprContact(HapprContact happrContact) async{
    happrContact.ownerUsername = await PrefManager.getLoginUsername();
    await _happrContactCollectionsRef.doc(happrContact.id).set(happrContact.toMap(), SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getHapprContactsAsStream(){
    final username = _loggedInUsernameController.loggedInUserEmail;
    return _happrContactCollectionsRef.where("ownerUsername", isEqualTo: username).snapshots();
  }

  Future<List<HapprContact>> getAllHapprContacts() async{
    final username = await PrefManager.getLoginUsername();
    final querySnapshot =await _happrContactCollectionsRef.where("ownerUsername", isEqualTo: username).get();
    final docs = querySnapshot.docs;
    final happrContactsList = docs.map((doc) => HapprContact.fromMap(doc.data())).toList();
    return happrContactsList;
  }

  Future<void> setHapprContactRating({@required HapprContact happrContact, @required double rating}) async{
        final docSnapshot = await _happrContactCollectionsRef.doc(happrContact.id).get();
    if(docSnapshot.exists){
      await docSnapshot.reference.set({"rating" : rating}, SetOptions(merge: true));
    }else {
      await postHapprContact(happrContact);
    }
  }

  String getHapprContactId(){
    final id = _happrContactCollectionsRef.doc().id;
    return id;
  }
}