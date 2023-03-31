import 'package:flutter/material.dart';
import 'package:project_oneplanet/helper/firestore_methods.dart';
import 'package:project_oneplanet/models/Event.dart';

class EventDetailsBackground extends StatefulWidget {
  String eventID;

  EventDetailsBackground({required this.eventID});
  @override
  State<EventDetailsBackground> createState() => _EventDetailsBackgroundState();
}

class _EventDetailsBackgroundState extends State<EventDetailsBackground> {
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.topCenter,
      child: ClipPath(
        clipper: ImageClipper(),
        child: Image.network(
          event != null ? event!.photo : "https://picsum.photos/200/300",
          fit: BoxFit.cover,
          width: screenWidth,
          color: Color(0x99000000),
          colorBlendMode: BlendMode.darken,
          height: screenHeight * 0.5,
        ),
      ),
    );
  }
}

class ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset curveStartingPoint = Offset(0, 40);
    Offset curveEndPoint = Offset(size.width, size.height * 0.95);
    path.lineTo(curveStartingPoint.dx, curveStartingPoint.dy - 5);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.85,
        curveEndPoint.dx - 60, curveEndPoint.dy + 10);
    path.quadraticBezierTo(size.width * 0.99, size.height * 0.99,
        curveEndPoint.dx, curveEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
