class HapprContact {
  String id;
  String displayName;
  String initials;
  int rating;
  String phone;

  HapprContact({this.id, this.displayName, this.initials, this.rating, this.phone});

  factory HapprContact.fromMap(Map<String, dynamic> map){
    return HapprContact(
      id : map["id"],
      displayName: map["displayName"],
      initials: map["initials"],
      rating: map["rating"],
      phone: map["phone"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "displayName" : displayName,
      "initials" : initials,
      "rating" : rating,
      "phone" : phone
    };
  }
}