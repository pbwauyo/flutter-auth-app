class Memory {
  String id;
  String title;
  String image;
  String ownerImage;
  double rating;
  String momentId;

  Memory({this.id, this.title, this.image, this.ownerImage, this.rating, this.momentId});

  factory Memory.fromMap(Map<String, dynamic> map){
    return Memory(
      id: map["id"],
      title: map["title"],
      image: map["image"],
      ownerImage: map["ownerImage"],
      rating: map["rating"],
      momentId: map["momentId"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "title": title,
      "image" : image ?? "",
      "ownerImage" : ownerImage ?? "",
      "rating" : rating ?? 0.0,
      "momentId" : momentId
    };
  }
}