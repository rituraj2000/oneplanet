import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../Models//Event.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> uploadScheduledEvent(
    String title,
    String eventID,
    String description,
    String date,
    String location,
    String lat,
    String lon,
    String type,
  ) async {
    String res = "";

    try {
      //String eventIDd = const Uuid().v1();

      Event event = Event(
        userID: _firebaseAuth.currentUser!.uid,
        eventID: eventID,
        title: title,
        description: description,
        lat: lat,
        lon: lon,
        date: date,
        type: type,
        location: location,
      );
      _firestore.collection('events').doc(eventID).set(event.toJson());
      res = "successfully scheduled new event";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> addUserToEventGroup(String userID, String eventID) async {
    String res = "Failed to add to group";

    try {
      // final eventDocs = await _firestore
      //     .collection('users')
      //     .doc(
      //       userID.toString(),
      //     )
      //     .collection('my-events')
      //     .get();

      // List<DocumentSnapshot> _myEventList = eventDocs.docs.toList();

      print(userID);
      _firestore.collection('users').doc(userID).update(
        {
          'my-events': FieldValue.arrayUnion([eventID]),
        },
      );

      res = "success";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }
}
