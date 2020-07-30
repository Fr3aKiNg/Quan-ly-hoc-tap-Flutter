import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:scheduleapp/utils/dao/note_dao.dart';
import 'package:scheduleapp/utils/model/TimeUtils.dart';

import 'noteItem.dart';
import 'tag.dart';

class Notes extends TimeUtils with ChangeNotifier {
  //@primaryKey
  String id;
  String title;
  List<Tag> tags;
  List<NoteItem> contents;
  List<String> history;

  //Constructor
  Notes() : super() {
    this.id = "note-" + UniqueKey().toString();
    this.title = "New untitled note";
    this.tags = new List<Tag>();
    this.contents = new List<NoteItem>();
    this.history = new List<String>();
    this.history.add(TimeUtils.formatter.format(DateTime.now()));
  }

  Notes.fullData(this.id, this.title, this.tags, this.contents,
      DateTime create_time, DateTime modified_time) {
    this.created_time = create_time;
    this.modified_time = modified_time;
  }
  Notes.withBasicInfo(
      this.id, this.title, DateTime created_time, DateTime modified_time) {
    this.tags = new List<Tag>();
    this.contents = new List<NoteItem>();
    this.created_time = created_time;
    this.modified_time = modified_time;
  }
  Notes.withTitle(String title) : super() {
    this.id = "note-" + UniqueKey().toString();
    this.tags = new List<Tag>();
    this.contents = new List<NoteItem>();
    this.history = new List<String>();
    this.history.add(TimeUtils.formatter.format(DateTime.now()));
    this.title = title;
  }

  Notes.withTag(Tag tag) : super() {
    this.id = "note-" + UniqueKey().toString();
    this.title = "New Note";
    this.tags = new List<Tag>();
    this.contents = new List<NoteItem>();
    this.history = new List<String>();
    this.history.add(TimeUtils.formatter.format(DateTime.now()));
    this.tags.add(tag);
  }

  //Set Attribute
  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void removeTitle() {
    this.title = "New Note";
  }

  void setTag(List<Tag> tags) {
    this.tags.addAll(tags);
    notifyListeners();
  }

  void addTag(Tag tag) {
    this.tags.add(tag);
    notifyListeners();
  }

  void removeTag(List<Tag> tags) {
    tags.forEach((element) => this.tags.remove(element));
    notifyListeners();
  }

  void setNoteItem(List<NoteItem> noteItems) {
    this.contents.addAll(noteItems);
    notifyListeners();
  }

  void addNoteItem(NoteItem noteItem) {
    this.contents.add(noteItem);
    notifyListeners();
  }

  void removeNoteItem(NoteItem noteItem) {
    this.contents.remove(noteItem);
    notifyListeners();
  }

  NoteItem getNoteItemAt(index) {
    return this.contents[index];
  }

  String toString() {
    String noteItem = "";
    if (contents != null) {
      contents
          .forEach((f) => {noteItem = noteItem + "\t\t" + f.toString() + "\n"});
    }
    String tag = "";
    if (tags != null) {
      tags.forEach((f) => {tag = tag + "\t\t" + f.toString() + "\n"});
    }

    return "<Note ID=\"" +
        id.toString() +
        "\" Title=\"" +
        title +
        "\" Created_Time=\"" +
        created_time.toString() +
        "\" Modified_Time=\"" +
        modified_time.toString() +
        "\">\n\t<Tags>\n" +
        tag +
        "\t</Tags>\n" +
        "\t<NoteItems>\n" +
        noteItem +
        "\t</NoteItems>\n" +
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

  UnmodifiableListView<NoteItem> get allTasks =>
      UnmodifiableListView(this.contents);
  void setListNoteItems(List<NoteItem> listNoteItem) {
    this.contents = listNoteItem;
  }
}
