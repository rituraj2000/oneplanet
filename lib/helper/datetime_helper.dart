import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// For getting formatted time from millisecond since epoch time
class MyDateHelper {
  static String getFormattedTime({required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    DateTime timenow = DateTime.now();
    if(DateFormat.yMMMd().format(date) == DateFormat.yMMMd().format(timenow)) {
      return TimeOfDay.fromDateTime(date).format(context); // Same day
    } else if (DateFormat.y().format(date) == DateFormat.y().format(timenow)){
      return DateFormat.MMMd().format(date); //Same year case
    } else {
      return DateFormat.yMd().format(date); //Different year case
    }
  }

  static String getAccountFormattedTime({required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    DateTime timenow = DateTime.now();
    if(DateFormat.yMMMd().format(date) == DateFormat.yMMMd().format(timenow)) {
      return "Last seen today at ${TimeOfDay.fromDateTime(date).format(context)}"; // Same day
    } else if (DateFormat.y().format(date) == DateFormat.y().format(timenow)){
      return "Last seen on ${DateFormat.MMMd().format(date)}"; //Same year case
    } else {
      return "Last seen ${DateFormat.yMd().format(date)}"; //Different year case
    }
  }
}