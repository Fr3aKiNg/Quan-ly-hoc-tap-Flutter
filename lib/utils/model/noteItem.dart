import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:note_app/utils/model/TimeUtils.dart';

enum NoteItemType { TEXT, IMAGE, AUDIO }

class NoteItem extends TimeUtils {
  //@primaryKey
  String id;
  String content;
  String type;
  Color noteColor;
  NoteItem(this.type) : super() {
    this.id = "noteItem-" + UniqueKey().toString();
  }
//  Future<Uint8List> enCodeImg() {
//    Uint8List bytes;
//    File imgFile = File(this.content);
//    bytes = imgFile.readAsBytesSync();
//    return bytes;
//  }
  NoteItem.withFullInfo(this.id, this.type, this.content, this.noteColor,
      DateTime createdTime, DateTime modifiedTime) {
    this.created_time = createdTime;
    this.modified_time = modifiedTime;
  }

  //SetAttribute
  void setContent(String content) {
    this.content = content;
  }

  void setBgColor(Color color) {
    this.noteColor = color;
  }

  String toString() {
    return "<NoteItem ID=\"" +
        id.toString() +
        "\" Type=\"" +
        type +
        "\" Content=\"" +
        content.toString() +
        "\" Color=\"" +
        noteColor.toString() +
        "\" Created_Time=\"" +
        created_time.toString() +
        "\" Modified_Time=\"" +
        modified_time.toString() +
        "\"/>";
  }

  Map<String, dynamic> toDatabaseJson(String noteId) {
    var formatter = TimeUtils.formatter;
    return {
      'noteItem_id': id,
      'note_id': noteId,
      'type': type,
      'content': content,
      'note_color': noteColor == null ? 0 : noteColor.value,
      'created_time': formatter.format(created_time),
      'modified_time': formatter.format(modified_time)
    };
  }

  Map<String, dynamic> toDatabaseJsonWithOutNoteID() {
    var formatter = TimeUtils.formatter;
    return {
      'noteItem_id': id,
      'type': type,
      'content': content,
      'note_color': noteColor == null ? 0 : noteColor.value,
      'created_time': formatter.format(created_time),
      'modified_time': formatter.format(modified_time)
    };
  }

  factory NoteItem.fromDatabaseJson(Map<String, dynamic> data) =>
      NoteItem.withFullInfo(
          data['noteItem_id'],
          data['type'],
          data['content'],
          Color(data['note_color']),
          DateTime.parse(data['created_time']),
          DateTime.parse(data['modified_time']));
}
