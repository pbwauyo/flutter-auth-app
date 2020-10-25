class Moment {
  String id;
  String title;
  String location;
  String attendees;
  String dateTime;
  String notes;
  String imageUrl;
  String category;

  Moment({this.id, this.title, this.location, this.attendees, this.dateTime, this.notes, this.imageUrl, this.category});

  factory Moment.fromMap(Map<String, dynamic> map){
    return Moment(
      id: map["id"],
      title: map["title"],
      location: map["location"],
      attendees: map["attendees"],
      dateTime: map["dateTime"],
      notes: map["notes"],
      imageUrl: map["imageUrl"],
      category: map["category"]
    );
  }

  Map<String, String> toMap(){
    return {
      "id" : id,
      "title" : title ?? "",
      "location" : location ?? "",
      "attendees" : attendees ?? "",
      "dateTime" : dateTime ?? "",
      "notes" : notes ?? "",
      "imageUrl" : imageUrl ?? "",
      "category" : category ?? ""
    };
  }
}