import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  final _timestampFormat = "yyyy-MM-dd HH:mm:ss";
  final _dateFormat = "yyyy-MM-dd";
  final _timeFormat = "HH:mm:ss";

  String getCurrentTimestamp() {
    return DateFormat(_timestampFormat).format(DateTime.now());
  }

  String getCurrentDate() {
    return DateFormat(_dateFormat).format(DateTime.now());
  }

  String getCurrentTime() {
    return DateFormat(_timeFormat).format(DateTime.now());
  }

  String getDisplayDate(String date) {
    return DateFormat.MMMEd().format(DateFormat(_dateFormat).parse(date));
  }

  DateTime getDate(String date) {
    return DateFormat(_dateFormat).parse(date);
  }

  Color getWeekColor(String date) {
    var color = Colors.white;
    var weekday = DateFormat(_dateFormat).parse(date).weekday;
    switch (weekday) {
      case DateTime.monday:
        {
          color = Colors.deepOrange[50];
        }
        break;
      case DateTime.tuesday:
        {
          color = Colors.deepOrange[100];
        }
        break;
      case DateTime.wednesday:
        {
          color = Colors.deepOrange[200];
        }
        break;
      case DateTime.thursday:
        {
          color = Colors.deepOrange[300];
        }
        break;
      case DateTime.friday:
        {
          color = Colors.deepOrange[400];
        }
        break;
      case DateTime.saturday:
        {
          color = Colors.deepOrange[500];
        }
        break;
      case DateTime.sunday:
        {
          color = Colors.deepOrange[600];
        }
        break;
    }
    return color;
  }
}
