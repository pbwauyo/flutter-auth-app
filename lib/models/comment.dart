class Comment {
  String id;
  String timestamp;
  String text;
  String commenterUsername;
  String artifactId; //can be moment or memory
  double rating;

  Comment({this.id, this.timestamp, this.text, this.commenterUsername, this.artifactId, this.rating});

  factory Comment.fromMap(Map<String, dynamic> map){
    return Comment(
      id: map["id"],
      timestamp: map["timestamp"],
      text: map["text"],
      commenterUsername: map["commenterUsername"],
      artifactId: map["artifactId"],
      rating: map["rating"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "timestamp" : timestamp,
      "text" : text,
      "commenterUsername" : commenterUsername,
      "artifactId" : artifactId,
      "rating" : rating ?? 0.0
    };
  }
}