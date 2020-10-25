import 'package:auth_app/models/moment.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MomentRepo {
  final _firestore = FirebaseFirestore.instance;
  final _userRepo = UserRepo();

  CollectionReference get _collectionRef => _firestore.collection("moments");

  Future<void> saveMoment(Moment moment) async{
    final id = _collectionRef.doc().id;
    moment.id = id;
    await _collectionRef.doc(id).set(moment.toMap());
  }

  Stream<QuerySnapshot> getMomentsAsStream(){
    return _collectionRef.snapshots();
  }

  Future<void> updateMomentImage(String momentId, String filePath,) async{
    final downloadUrl = _userRepo.uploadFile(filePath: filePath, folderName: "moment_images");
    await _collectionRef.doc(momentId).set({"imageUrl" : downloadUrl}, SetOptions(merge: true));
  }

}