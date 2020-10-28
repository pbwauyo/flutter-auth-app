import 'package:auth_app/models/memory.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class MemoryRepo {
  final _firestore = FirebaseFirestore.instance;
  final _userRepo = UserRepo();

  CollectionReference get  _memoriesCollectionRef => _firestore.collection("memories");

  Stream<QuerySnapshot> getMomentMemoriesAsStream({@required String momentId}){
    return _memoriesCollectionRef.where("momentId", isEqualTo: momentId).snapshots();
  }

  Stream<QuerySnapshot> getAllMemoriesAsStream(){
    return _memoriesCollectionRef.snapshots();
  }

  Future<void> updateMemoryRating({@required String memoryId, @required double newRating}) async{
    await _memoriesCollectionRef.doc(memoryId).set({"rating": newRating}, SetOptions(merge: true));
  }

  Future<void> postMemory(Memory memory, String imageFilePath) async{
    final id = _memoriesCollectionRef.doc().id;
    final downloadUrl = await _userRepo.uploadFile(filePath: imageFilePath, folderName: "memory_images");
    memory.id = id;
    memory.image = downloadUrl;
    await _memoriesCollectionRef.doc(id).set(memory.toMap());
    
  }

  Future<Memory> getMemory(String memoryId) async{
    final docSnapshot = await _memoriesCollectionRef.doc(memoryId).get();
    return Memory.fromMap(docSnapshot.data());
  }
}