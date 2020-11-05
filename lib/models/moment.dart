class Moment {
  String id;
  String creator;
  String title;
  String location;
  List<Map<String, String>> attendees;
  String startDateTime;
  String endDateTime;
  DateTime realStartDateTime;
  DateTime realEndDateTime;
  String notes;
  String imageUrl;
  String category;
  String momentCalenderId;

  Moment({this.id, this.creator, this.title, this.location, this.attendees, this.startDateTime, this.endDateTime, 
  this.notes, this.imageUrl, this.category, this.momentCalenderId, this.realStartDateTime, this.realEndDateTime});

  factory Moment.fromMap(Map<String, dynamic> map){
    return Moment(
      id: map["id"],
      creator: map["creator"],
      title: map["title"],
      location: map["location"],
      attendees: List<dynamic>.from(map["attendees"]).cast<Map<String, String>>(),
      startDateTime: map["dateTime"],
      endDateTime: map["endDateTime"],
      notes: map["notes"],
      imageUrl: map["imageUrl"],
      category: map["category"],
      momentCalenderId: map["momentCalenderId"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "creator" : creator,
      "title" : title ?? "",
      "location" : location ?? "",
      "attendees" : attendees ?? [],
      "dateTime" : startDateTime ?? "",
      "endDateTime" : endDateTime ?? "",
      "notes" : notes ?? "",
      "imageUrl" : imageUrl ?? "",
      "category" : category ?? "",
      "momentCalenderId" : momentCalenderId ?? ""
    };
  }
}