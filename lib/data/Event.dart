import 'package:flutter/cupertino.dart';

class Event {
  String name;
  String timeline;
  Event(this.name, this.timeline);
}
class EventInDay{
  String date;
  String dayInWeek;
  final List<Event> eventOfTheDay;
  EventInDay({@required String date, @required String day,@required List<Event> list}):
      date = date,
      dayInWeek = day,
      eventOfTheDay = list;
}