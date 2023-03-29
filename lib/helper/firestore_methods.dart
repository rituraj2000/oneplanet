import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_oneplanet/apis/apis.dart';
import 'package:uuid/uuid.dart';
import '../models/Event.dart';

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

      EventModel event = EventModel(
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

  Future<EventModel?> getEventById(String eventID) async {
    EventModel? event;
    DocumentSnapshot docSnap =
        await APIs.firestore.collection("events").doc(eventID).get();

    if (docSnap.data() != null) {
      event = EventModel.fromSnap(docSnap);
    }
    return event;
  }

  Future<String> addUserToEventGroup(String eventID) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    String res = "Failed to add to group";

    try {
      _firestore.collection('users').doc(uid).update(
        {
          'my-events': FieldValue.arrayUnion([eventID]),
        },
      );

      _firestore.collection('events').doc(eventID).update({
        'participants': FieldValue.arrayUnion([uid]),
      });
      res = "success";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  Future<List<EventModel>> getAllChatRoomsOfCurrentUser() async {
    List<EventModel> _myEvents = [];
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      final userDetails =
          await APIs.firestore.collection('users').doc(uid).get();
      final events = userDetails.data()!['my-events'];

      for (var event in events) {
        final eventDetails =
            await APIs.firestore.collection('events').doc(event).get();
        _myEvents.add(EventModel.fromSnap(eventDetails));
      }
    } catch (e) {
      print(e.toString());
    }

    print(_myEvents);
    return _myEvents;
  }

  Future<String> sendMessage(String msg) async {
    String res = "failed to send message";

    try {
      //await APIs.firestore.collection('messages').doc().set();
      res = "Successfully Sent message";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }
}
