import 'package:cloud_firestore/cloud_firestore.dart';

class Memory {
  String id;
  String title;
  String image;
  String ownerImage;
  double rating;
  String momentId;
  String timestamp;

  Memory({this.id, this.title, this.image, this.ownerImage, this.rating, this.momentId, this.timestamp});

  factory Memory.fromMap(Map<String, dynamic> map){
    return Memory(
      id: map["id"],
      title: map["title"],
      image: map["image"],
      ownerImage: map["ownerImage"],
      rating: map["rating"],
      momentId: map["momentId"],
      timestamp: map["timestamp"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "title": title,
      "image" : image ?? "",
      "ownerImage" : ownerImage ?? "",
      "rating" : rating ?? 0.0,
      "momentId" : momentId,
      "timestamp" : Timestamp.now().nanoseconds.toString()
    };
  }
}