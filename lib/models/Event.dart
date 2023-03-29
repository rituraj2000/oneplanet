import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String userID;
  final String eventID;
  final String title;
  final String description;
  final String location;
  final String lat;
  final String lon;
  final String date;
  final String eventTime;
  final String type;
  final String photo;

   Event({
    required this.userID,
    required this.eventID,
    required this.title,
    required this.description,
    required this.location,
    required this.lat,
    required this.lon,
    required this.date,
    required this.eventTime,
    required this.type,
    required this.photo,
  });

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Event(
      userID: snapshot['userID'],
      eventID: snapshot['eventID'],
      title: snapshot['title'],
      description: snapshot['description'],
      lat: snapshot['lat'],
      lon: snapshot['lon'],
      date: snapshot['date'],
      eventTime: snapshot['eventtime'],
      type: snapshot['type'],
      location: snapshot['location'],
      photo: snapshot['photo'],
    );
  }


  Map<String, dynamic> toJson() => {
        "userID": userID,
        "title": title,
        "description": description,
        "lat": lat,
        "lon": lon,
        "eventID": eventID,
        "date": date,
        "eventtime": eventTime,
        "type": type,
        "location": location,
        "photo": photo,
      };
}
