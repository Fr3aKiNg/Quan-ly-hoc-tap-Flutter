import 'package:cloud_firestore/cloud_firestore.dart';

class Event{
  String title;
  String description;
  DateTime time;

  DocumentReference reference;
  Event(this.title,this.description,this.time);
  factory Event.fromJson(Map<dynamic, dynamic> json) => _EventFromJson(json);
  Map<String, dynamic> toJson() => _EventToJson(this);
  @override
  String toString() => "Event<$title><$time>";
}
//1
Event _EventFromJson(Map<dynamic, dynamic> json) {
  return Event(
    json['title'] as String,
    json['description'] as String,
    json['time'] == null ? null : (json['time'] as Timestamp).toDate(),
  );
}
//2
Map<String, dynamic> _EventToJson(Event instance) =>
    <String, dynamic> {
      'title': instance.title,
      'description': instance.description,
      'time': instance.time,
    };
