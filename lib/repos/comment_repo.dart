import 'package:auth_app/models/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentRepo {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _commentsCollectionRef => _firestore.collection("comments");

  Stream<QuerySnapshot> getCommentsAsStream({@required String artifactId}){
    return _commentsCollectionRef.where("artifactId", isEqualTo: artifactId).orderBy("timestamp").snapshots();
  }

  Future<void> updateCommentRating({@required String commentId, @required double newRating}) async{
    await _commentsCollectionRef.doc(commentId).set({"rating": newRating}, SetOptions(merge: true));
  }

  Future<void> postComment(Comment comment) async{
    final id = _commentsCollectionRef.doc().id;
    comment.id = id;
    comment.timestamp = Timestamp.now().nanoseconds.toString();
    await _commentsCollectionRef.doc(id).set(comment.toMap());
  }
}

