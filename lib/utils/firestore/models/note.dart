import 'package:cloud_firestore/cloud_firestore.dart';

class Note{
  String title;
  String content;

  DocumentReference reference;
  Note(this.title,this.content);
  factory Note.fromJson(Map<dynamic, dynamic> json) => _NoteFromJson(json);
  Map<String, dynamic> toJson() => _NoteToJson(this);
  @override
  String toString() => "Note<$title>";
}
Note _NoteFromJson(Map<dynamic, dynamic> json) {
  return Note(
    json['title'] as String,
    json['content'] as String,
  );
}
//2
Map<String, dynamic> _NoteToJson(Note instance) =>
    <String, dynamic> {
      'title': instance.title,
      'content': instance.content,
    };
