class HapprContact {
  String id;
  String displayName;
  String initials;
  double rating;
  String phone;
  String ownerUsername;

  HapprContact({this.id, this.displayName, this.initials, this.rating, this.phone, this.ownerUsername});

  factory HapprContact.fromMap(Map<String, dynamic> map){
    return HapprContact(
      id : map["id"],
      displayName: map["displayName"],
      initials: map["initials"],
      rating: map["rating"],
      phone: map["phone"],
      ownerUsername: map["ownerEmail"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "displayName" : displayName,
      "initials" : initials,
      "rating" : rating ?? 0.0,
      "phone" : phone ?? "",
      "ownerEmail" : ownerUsername
    };
  }
}