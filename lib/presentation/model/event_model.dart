import 'package:flutter/material.dart';

class Event{
  String name;
  String desc;
  DateTime from;
  DateTime to;
  Color color;
  Event(this.name,this.desc,this.from,this.to,this.color);
  DateTime getDate(){
    return from;
  }
}