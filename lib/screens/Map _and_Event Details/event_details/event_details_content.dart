import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_oneplanet/helper/firestore_methods.dart';
import 'package:project_oneplanet/models/Event.dart';
import 'package:project_oneplanet/theme/colors.dart';

class EventDetailsContent extends StatefulWidget {
  String eventID;

  EventDetailsContent({required this.eventID});
  @override
  State<EventDetailsContent> createState() => _EventDetailsContentState();
}

class _EventDetailsContentState extends State<EventDetailsContent> {
  //failed to join | Not Joined | Already Joined
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
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
            child: Text(
              event != null ? event!.title : "Title",
              style: TextStyle(
                fontSize: 38.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.24),
            child: FittedBox(
              child: Row(
                children: <Widget>[
                  Text(
                    "-",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 239, 230, 230),
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    event != null ? event!.location : "event location",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Participants",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                color: AppColors.kDarkGreen,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                if (event != null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(4, 3),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(4, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        "https://pbs.twimg.com/profile_images/980145664712740864/aNWjR7MB_400x400.jpg",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(4, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cmFuZG9tJTIwcGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(4, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        "https://randomuser.me/api/portraits/men/82.jpg",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: event != null ? event!.description : "Description",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.kTextDarkGreen,
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: EventDateWidget(
              eventDate: event != null ? int.parse(event!.date) : 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: JoinButton(
              joining_stat: joining_status,
              ontTap: () {
                _joinGroup();
              },
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
            : AppColors.kCardTagGreen,
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
            color: Colors.white,
          ),
        ),
      ),
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

class EventDateWidget extends StatelessWidget {
  final int eventDate;
  EventDateWidget({required this.eventDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.calendar_month,
          size: 25,
          color: AppColors.grey,
        ),
        const SizedBox(width: 10.0),
        Text(
          '${formatDateTime(eventDate)}',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }
}
