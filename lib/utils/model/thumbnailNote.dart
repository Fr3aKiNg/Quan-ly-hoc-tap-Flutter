import 'package:flutter/cupertino.dart';
import 'package:scheduleapp/utils/model/TimeUtils.dart';
import 'package:scheduleapp/utils/model/tag.dart';

class ThumbnailNote {
  final String noteId;
  final String title;
  List<Tag> tags;
  final String type;
  final Color color;
  final String content;
  final DateTime createdTime;
  final DateTime modifiedTime;

  ThumbnailNote(this.noteId, this.title, this.tags, this.type, this.color,
      this.content,this.createdTime, this.modifiedTime);

  ThumbnailNote.withOutTag(this.noteId, this.title, this.type, this.color,
      this.content,this.createdTime, this.modifiedTime) {
    this.tags = new List<Tag>();
  }

  ThumbnailNote setTag(List<Tag> tags) {
    this.tags.addAll(tags);
    return this;
  }

  String toString() {
    String tag = "";
    if (tags != null) {
      tags.forEach((f) => {tag = tag + "\t\t" + f.toString() + "\n"});
    }
    String text = "<Thumbnail Note_id=\"" +
        noteId.toString() +
        "\" Title=\"" +
        title +
        "\" Type=\"" +
        type.toString() +
        "\" Color=\"" +
        color.toString() +
        "\" Content=\"" +
        content +
        "\" Created_Time=\"" +
        createdTime.toString() +
        "\" Modified_Time=\"" +
        modifiedTime.toString() +
        "\">\n\t<Tags>\n" +
        tag +
        "\t</Tags>\n" +
        "</Thumbnail>";
    return text;
  }

  ThumbnailNote.withBasicInfo(this.noteId, this.title, this.type, this.color,
      this.content,this.createdTime, this.modifiedTime) {
    this.tags = new List<Tag>();
  }

  factory ThumbnailNote.fromDatabaseJson(Map<String, dynamic> data) =>
      ThumbnailNote.withBasicInfo(
          data['note_id'],
          data['title'],
          data['type'],
          Color(data['color']),
          data['content'],
          DateTime.parse(data['created_time']),
          DateTime.parse(data['modified_time']));

  Map<String, dynamic> toDatabaseJson() {
    var formatter = TimeUtils.formatter;
    return {
      'note_id': noteId,
      'title': title,
      'type': type,
      'color': color == null ? 0 : color.value,
      'content': content,
      'created_time': formatter.format(createdTime),
      'modified_time': formatter.format(modifiedTime)
    };
  }

  factory ThumbnailNote.fromDatabaseJsonWithTags(
          Map<String, dynamic> data, List<Tag> tags) =>
      ThumbnailNote(
          data['note_id'],
          data['title'],
          tags,
          data['type'],
          Color(data['color']),
          data['content'],
          DateTime.parse(data['created_time']),
          DateTime.parse(data['modified_time']));
}
