class Moment {
  String id;
  String creator;
  String title;
  String location;
  List<Map<String, String>> attendees;
  String dateTime;
  String notes;
  String imageUrl;
  String category;

  Moment({this.id, this.creator, this.title, this.location, this.attendees, this.dateTime, this.notes, this.imageUrl, this.category});

  factory Moment.fromMap(Map<String, dynamic> map){
    return Moment(
      id: map["id"],
      creator: map["creator"],
      title: map["title"],
      location: map["location"],
      attendees: List<dynamic>.from(map["attendees"]).cast<Map<String, String>>(),
      dateTime: map["dateTime"],
      notes: map["notes"],
      imageUrl: map["imageUrl"],
      category: map["category"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "creator" : creator,
      "title" : title ?? "",
      "location" : location ?? "",
      "attendees" : attendees ?? [],
      "dateTime" : dateTime ?? "",
      "notes" : notes ?? "",
      "imageUrl" : imageUrl ?? "",
      "category" : category ?? ""
    };
  }
}