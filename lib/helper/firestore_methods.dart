import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_oneplanet/apis/apis.dart';
import 'package:project_oneplanet/models/MessagesModel.dart';
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
    String eventTime,
    String photo,
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
        eventTime: eventTime,
        photo: photo,
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
    try {
      DocumentSnapshot docSnap =
          await APIs.firestore.collection("events").doc(eventID).get();

      if (docSnap.data() != null) {
        event = EventModel.fromSnap(docSnap);
      } else {
        print("Failed!");
      }
    } catch (e) {
      print(e.toString());
    }

    return event;
  }

  Future<String> addUserToEventGroup(String eventID) async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    String res = "failed";
    try {
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

    return _myEvents;
  }

  Future<String> sendMessage(String msg, String eventId) async {
    String res = "failed";
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await APIs.firestore
          .collection('messages')
          .doc(DateTime.now().microsecondsSinceEpoch.toString())
          .set(
            MessageModel(from: uid, message: msg, eventId: eventId).toJson(),
          );
      res = "successfull";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }
}
