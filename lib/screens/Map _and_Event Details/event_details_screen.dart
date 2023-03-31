import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project_oneplanet/models/Event.dart';
import '../../helper/firestore_methods.dart';
import 'package:project_oneplanet/screens/Chat%20Rooms/event_chat_room.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventID;

  EventDetailsScreen({required this.eventID});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  //failed to join | Not Joined | Already Joined
  //            -1 |          0 |             1
  int joining_status = 0;

  void _joinGroup() async {
    String userID = await FirebaseAuth.instance.currentUser!.uid;

    try {
      String res = await FirestoreMethods().addUserToEventGroup(widget.eventID);

      if (res == 'success') {
        setState(() {
          joining_status = 1;
        });

        print(joining_status);
      } else {
        joining_status = -1;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  EventModel? event;

  void _setCurrentEvent() async {
    EventModel? res = await FirestoreMethods().getEventById(widget.eventID);

    setState(() {
      event = res;
    });
  }

  @override
  void initState() {
    super.initState();
    _setCurrentEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E8747),
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      event != null
                          ? event!.photo
                          : 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/08/E-Goal-06-1024x1024.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Expanded(
            flex: 3,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2E8747),
                //boxShadow: [BoxShadow(blurRadius: 6)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventTitle(
                        title: event != null ? event!.title : "NULL",
                        participant_count:
                            event != null ? event!.participants.length : 0,
                      ),
                      JoinButton(
                        ontTap: () {
                          _joinGroup();
                        },
                        joining_stat: (event != null &&
                                event!.participants.contains(
                                    FirebaseAuth.instance.currentUser!.uid))
                            ? 1
                            : joining_status,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EventLocationWidget(
                          locationName:
                              event != null ? event!.location : "NULL"),
                      EventDateWidget(
                          eventDate:
                              event != null ? int.parse(event!.date) : 0),
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
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 30, color: Colors.black.withOpacity(0.2))
                ],
              ),
              child: Text(
                event != null ? event!.description : "NULL",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JoinButton extends StatelessWidget {
  final Function ontTap;
  int joining_stat = 0;

  JoinButton({
    required this.ontTap,
    required this.joining_stat,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ontTap();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: (joining_stat == 1)
            ? Color.fromARGB(255, 17, 200, 206)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5.0,
        shadowColor: Colors.black54,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: Text(
          (joining_stat == 1) ? 'Joined In!' : 'Join',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: (joining_stat == 1) ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class EventDateWidget extends StatelessWidget {
  final int eventDate;
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
          '${formatDateTime(eventDate)}',
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
        SizedBox(
          width: 150,
          child: Text(
            locationName,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }
}

class EventTitle extends StatelessWidget {
  final String title;
  final int participant_count;
  EventTitle({required this.title, required this.participant_count});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            '${title.toUpperCase()}',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          '${participant_count} Participants',
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

String formatDateTime(int millisecondsSinceEpoch) {
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  String year = dateTime.year.toString().substring(2);
  return '$day | $month | $year';
}
