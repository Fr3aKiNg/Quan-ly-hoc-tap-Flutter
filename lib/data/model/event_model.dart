import 'package:firebase_helpers/firebase_helpers.dart';

class EventModel extends DatabaseItem{
  final String id;
  final String uid;
  final String title;
  final String description;
  final DateTime eventDateFrom;
  final DateTime eventDateTo;
 // final int color;

  EventModel({this.id,this.uid,this.title, this.description, this.eventDateFrom,this.eventDateTo, }):super(id);

  factory EventModel.fromMap(Map data) {
    return EventModel(
      uid: data['uid'],
      title: data['title'],
      description: data['description'],
      eventDateFrom: data['event_date_from'],
      eventDateTo: data['event_date_to'],
     // color: data['color'],
    );
  }

  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    return EventModel(
      id: id,
      uid: data['uid'],
      title: data['title'],
      description: data['description'],
      eventDateFrom: data['event_date_from'].toDate(),
      eventDateTo: data['event_date_to'].toDate(),
      //color: data['color'],
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "description": description,
      "event_date_from":eventDateFrom,
      "event_date_to":eventDateTo,
     // "color":color,
      "uid":uid,
      "id":id,
    };
  }
}