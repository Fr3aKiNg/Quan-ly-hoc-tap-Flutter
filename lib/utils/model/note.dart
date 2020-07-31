import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:scheduleapp/utils/dao/note_dao.dart';
import 'package:scheduleapp/utils/model/TimeUtils.dart';
class Notes extends TimeUtils with ChangeNotifier {
  //@primaryKey
  String id;
  String title;
  List<String> history;

  //Constructor
  Notes() : super() {
    this.id = "note-" + UniqueKey().toString();
    this.title = "New untitled note";
    this.history = new List<String>();
    this.history.add(TimeUtils.formatter.format(DateTime.now()));
  }

  Notes.fullData(this.id, this.title,
      DateTime create_time, DateTime modified_time) {
    this.created_time = create_time;
    this.modified_time = modified_time;
  }
  Notes.withBasicInfo(
      this.id, this.title, DateTime created_time, DateTime modified_time) {
    this.created_time = created_time;
    this.modified_time = modified_time;
  }
  Notes.withTitle(String title) : super() {
    this.id = "note-" + UniqueKey().toString();
    this.history = new List<String>();
    this.history.add(TimeUtils.formatter.format(DateTime.now()));
    this.title = title;
  }

  //Set Attribute
  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void removeTitle() {
    this.title = "New Note";
  }


  String toString() {
    return "<Note ID=\"" +
        id.toString() +
        "\" Title=\"" +
        title +
        "\" Created_Time=\"" +
        created_time.toString() +
        "\" Modified_Time=\"" +
        modified_time.toString() +
        "</Note>";
  }

  factory Notes.fromDatabaseJson(Map<String, dynamic> data) =>
      Notes.withBasicInfo(
          data['note_id'],
          data['title'],
          DateTime.parse(data['created_time']),
          DateTime.parse(data['modified_time']));
  Map<String, dynamic> toDatabaseJson() {
    var formatter = TimeUtils.formatter;
    return {
      'note_id': id,
      'title': title,
      'created_time': formatter.format(created_time),
      'modified_time': formatter.format(modified_time)
    };
  }
}
