import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project_oneplanet/models/Event.dart';
import '../../helper/firestore_methods.dart';
import 'package:project_oneplanet/screens/Chat%20Rooms/event_chat_room.dart';

class JoinButton extends StatelessWidget {
  final Function ontTap;

  JoinButton({
    required this.ontTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ontTap();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5.0,
        shadowColor: Colors.black54,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: Text(
          '+ Join',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class EventDateWidget extends StatelessWidget {
  final String eventDate;
  EventDateWidget({required this.eventDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.calendar_month,
          size: 15,
          color: Colors.white.withOpacity(0.6),
        ),
        const SizedBox(width: 10.0),
        Text(
          '${eventDate}',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }
}

class EventLocationWidget extends StatelessWidget {
  final String locationName;

  EventLocationWidget({required this.locationName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 15,
          color: Colors.white.withOpacity(0.6),
        ),
        const SizedBox(width: 10.0),
        Text(
          locationName,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }
}

class EventTitle extends StatelessWidget {
  final String title;
  EventTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${title}',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          '10 Participants',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class EventDetailsScreen extends StatefulWidget {
  final String eventID;

  EventDetailsScreen({required this.eventID});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  void _joinGroup(BuildContext ctx) async {
    String userID = await FirebaseAuth.instance.currentUser!.uid;

    try {
      String res = await FirestoreMethods().addUserToEventGroup(widget.eventID);

      if (res == "success") {
        Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (ctx) => EventChatRoom(),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  EventModel? event;

  void _setCurrentEvent() async {
    event = await FirestoreMethods().getEventById(widget.eventID);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _setCurrentEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://www.socialtables.com/wp-content/uploads/2016/10/iStock-540095978.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Expanded(
            flex: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2E8747),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventTitle(title: event != null ? event!.title : "NULL"),
                      JoinButton(ontTap: () {
                        _joinGroup(context);
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EventLocationWidget(
                          locationName:
                              event != null ? event!.location : "NULL"),
                      EventDateWidget(
                          eventDate: event != null ? event!.date : "NULL"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                event != null ? event!.description : "NULL",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
