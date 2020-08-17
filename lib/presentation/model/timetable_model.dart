import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/cupertino.dart';

class TimeTableModel extends DatabaseItem{
  final String id;
  String day;
  String order;
  String subject_name;
  String location;
  String teacher_name;
  Color color;

  TimeTableModel({this.id,this.subject_name, this.day,this.order,this.location, this.teacher_name, this.color}):super(id);
  TimeTableModel.empty(this.id):super(id){
      subject_name: "";
      day: "";
      order: "";
      location: "";
      teacher_name: "";
      color: Color(0);
  }
  TimeTableModel.name(this.id,this.subject_name):super(id){
    day: "";
    order: "";
    location: "";
    teacher_name: "";
    color: Color(0);
  }
  factory TimeTableModel.fromMap(Map data) {
    return TimeTableModel(
      subject_name: data['subject_name'],
      day: data['day'],
      order: data['order'],
      location: data['location'],
      teacher_name: data['teacher_name'],
      color: Color(int.parse(data['color'], radix: 16)),
    );
  }

  factory TimeTableModel.fromDS(String id, Map<String,dynamic> data) {
    return TimeTableModel(
      id: id,
      subject_name: data['subject_name'],
      location: data['location'],
      day: data['day'],
      order: data['order'],
      teacher_name: data['teacher_name'],
      color: Color(int.parse(data['color'], radix: 16)),
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "subject_name":subject_name,
      "day": day,
      "order": order,
      "location": location,
      "teacher_name":teacher_name,
      "color": color == null? 0:color.value,
      "id":id,
    };
  }
}