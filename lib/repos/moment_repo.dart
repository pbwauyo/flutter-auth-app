import 'package:auth_app/getxcontrollers/logged_in_username.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:provider/provider.dart';

class MomentRepo {
  final _firestore = FirebaseFirestore.instance;
  final _userRepo = UserRepo();
  final LoggedInUsernameController _loggedInUsernameController = Get.find();

  CollectionReference get _allMomentsCollectionRef => _firestore.collection("moments");

  Future<void> saveMoment(BuildContext context, Moment moment) async{
    final id = _allMomentsCollectionRef.doc().id;
    final filePathProvider =  Provider.of<FilePathProvider>(context, listen: false);
    final photoPath = filePathProvider.filePath;
    if(photoPath.trim().length > 0){
      final downloadUrl = await _userRepo.uploadFile(filePath: photoPath, folderName: "moment_images");
      moment.imageUrl = downloadUrl;
    }
    moment.id = id;
    moment.creator = await PrefManager.getLoginUsername();
    await _allMomentsCollectionRef.doc(id).set(moment.toMap(), SetOptions(merge: true));
    filePathProvider.filePath = ""; //reset file path
  }

  Stream<QuerySnapshot> getMomentsAsStream(){
    return _allMomentsCollectionRef.where("creator", isEqualTo: _loggedInUsernameController.loggedInUserEmail).snapshots();
  }

  Future<void> updateMomentImage(String momentId, String filePath,) async{
    final downloadUrl = await _userRepo.uploadFile(filePath: filePath, folderName: "moment_images");
    await _allMomentsCollectionRef.doc(momentId).set({"imageUrl" : downloadUrl}, SetOptions(merge: true));
  }

  Future<void> deleteMoment({@required String momentId}) async{
    await _allMomentsCollectionRef.doc(momentId).delete();
  }

  // Future<void> updateMoment({@required Moment newMoment}) async{
  //   await 
  // }
}