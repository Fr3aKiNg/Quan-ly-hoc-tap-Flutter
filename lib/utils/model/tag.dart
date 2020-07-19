import 'package:flutter/cupertino.dart';
import 'package:note_app/utils/model/TimeUtils.dart';

class Tag extends TimeUtils with ChangeNotifier {

  //@primaryKey
  String id;
  String title;
  Color color;

  Tag() : super() {
    this.id = "tag-"+UniqueKey().toString();
    this.title = "New Tag";
  }

  Tag.withFullInfo(this.id, this.title, this.color, DateTime createdTime,
      DateTime modifiedTime) {
    this.created_time = createdTime;
    this.modified_time = modifiedTime;
    notifyListeners();
  }

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setColor(Color color) {
    this.color = color;
    notifyListeners();
  }

  void setID(String ID) {
    this.id = ID;
    notifyListeners();
  }
//  Tag getTag() {
//    return this;
//  }

  String toString() {
    return "<Tag ID=\""+id.toString()+"\" Title=\"" +title.toString()  +
        "\" Color=\"" + color.toString() +
        "\" Created_Time=\"" + created_time.toString() +
        "\" Modified_Time=\"" + modified_time.toString()+
        "\"/>";
  }

  Map<String, dynamic> toDatabaseJson() {
    var formatter = TimeUtils.formatter;
    return {
      'tag_id':id,
      'title': title,
      'color': color == null ? 0 : color.value,
      'created_time': formatter.format(created_time),
      'modified_time': formatter.format(modified_time)
    };
  }

  factory Tag.fromDatabaseJson(Map<String, dynamic> data) => Tag.withFullInfo(
      data['tag_id'],
      data['title'],
      Color(data['color']),
      DateTime.parse(data['created_time']),
      DateTime.parse(data['modified_time']));
}
