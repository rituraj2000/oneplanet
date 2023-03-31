import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_oneplanet/apis/apis.dart';
import 'package:project_oneplanet/helper/firebase_helper.dart';
import 'package:project_oneplanet/models/user_model.dart';
import '../models/MessageModel.dart';
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
      List<String> participants = [];
      participants.add(FirebaseAuth.instance.currentUser!.uid);

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
        participants: participants,
      );
      _firestore.collection('events').doc(eventID).set(event.toJson());
      _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {
          'my-events': FieldValue.arrayUnion([eventID]),
        },
      );
      res = "successfully scheduled new event";
      print("Successfully  posted an event");
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

      // print(docSnap.data().toString());
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
        if (eventDetails.data() != null)
          _myEvents.add(EventModel.fromSnap(eventDetails));
      }
    } catch (e) {
      print("Firestore Err " + e.toString());
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
            MessageModel(
              from: uid,
              message: msg,
              eventId: eventId,
              profPic: FirebaseAuth.instance.currentUser!.photoURL,
            ).toJson(),
          );
      res = "successfull";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  Future<String> userProfileFromUserId(String uid) async {
    String res =
        "https://fastly.picsum.photos/id/137/200/300.jpg?hmac=5vAnK2h9wYgvt2769Z9D1XYb8ory9_zB0bqDgVjgAnk";

    try {
      final user = await APIs.firestore.collection('users').doc(uid).get();
      res = user.data()!['photo'];
    } catch (e) {
      print(e.toString());
    }

    return res;
  }
}
