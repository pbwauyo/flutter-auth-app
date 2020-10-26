import 'package:auth_app/models/moment.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MomentRepo {
  final _firestore = FirebaseFirestore.instance;
  final _userRepo = UserRepo();

  CollectionReference get _allMomentsCollectionRef => _firestore.collection("moments");

  Future<void> saveMoment(Moment moment) async{
    final id = _allMomentsCollectionRef.doc().id;
    moment.id = id;
    moment.creator = _userRepo.getCurrentUserEmail();
    await _allMomentsCollectionRef.doc(id).set(moment.toMap());
  }

  Stream<QuerySnapshot> getMomentsAsStream(){
    return _allMomentsCollectionRef.where("creator", isEqualTo: _userRepo.getCurrentUserEmail()).snapshots();
  }

  Future<void> updateMomentImage(String momentId, String filePath,) async{
    final downloadUrl = await _userRepo.uploadFile(filePath: filePath, folderName: "moment_images");
    await _allMomentsCollectionRef.doc(momentId).set({"imageUrl" : downloadUrl}, SetOptions(merge: true));
  }

}