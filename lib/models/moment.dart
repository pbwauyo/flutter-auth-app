class Moment {
  String id;
  String creator;
  String title;
  String location;
  List<Map<String, dynamic>> attendees;
  String startDateTime;
  String endDateTime;
  DateTime realStartDateTime;
  DateTime realEndDateTime;
  String notes;
  String imageUrl;
  String category;
  String momentCalenderId;
  String calendarId;

  Moment({this.id, this.creator, this.title, this.location, this.attendees, this.startDateTime, this.endDateTime, 
  this.notes, this.imageUrl, this.category, this.momentCalenderId, this.realStartDateTime, this.realEndDateTime, this.calendarId});

  factory Moment.fromMap(Map<String, dynamic> map){
    // print('ATTENDEES: ${map["attendees"]}');
    
    return Moment(
      id: map["id"],
      creator: map["creator"],
      title: map["title"],
      location: map["location"],
      attendees: List<Map<String, dynamic>>.from(map["attendees"]),
      startDateTime: map["dateTime"],
      endDateTime: map["endDateTime"],
      notes: map["notes"],
      imageUrl: map["imageUrl"],
      category: map["category"],
      momentCalenderId: map["momentCalenderId"],
      calendarId: map["calendarId"],
      realStartDateTime: (map["realStartDateTime"] != null && map["realStartDateTime"].toString().isNotEmpty && map["realStartDateTime"] != "null") ? DateTime.parse(map["realStartDateTime"]) : null,
      realEndDateTime: (map["realEndDateTime"] != null && map["realEndDateTime"].toString().isNotEmpty && map["realEndDateTime"] != "null") ? DateTime.parse(map["realEndDateTime"]) : null
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
      "momentCalenderId" : momentCalenderId ?? "",
      "calendarId" : calendarId ?? "",
      "realStartDateTime" : realStartDateTime.toString(),
      "realEndDateTime" : realEndDateTime.toString()
    };
  }
}