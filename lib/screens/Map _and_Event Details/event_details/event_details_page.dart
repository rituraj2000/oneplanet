import 'package:flutter/material.dart';
import 'package:project_oneplanet/theme/colors.dart';

import 'event_details_background.dart';
import 'event_details_content.dart';

class EventDetailsPage extends StatelessWidget {
  final String eventID;

  EventDetailsPage({required this.eventID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundGreen,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          EventDetailsBackground(eventID: eventID),
          EventDetailsContent(eventID: eventID),
        ],
      ),
    );
  }
}
