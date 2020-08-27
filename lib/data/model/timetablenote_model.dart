import 'package:firebase_helpers/firebase_helpers.dart';

class TimeTableNoteModel extends DatabaseItem{
  final String id;
  final String uid;
  final String description;
  final DateTime noteDate;
  final bool isDone;

  TimeTableNoteModel({this.id,this.uid,this.description, this.noteDate, this.isDone}):super(id);

  factory TimeTableNoteModel.fromMap(Map data) {
    return TimeTableNoteModel(
      uid: data['uid'],
      description: data['description'],
      noteDate: data['note_date'],
      isDone: data['is_done'],
    );
  }

  factory TimeTableNoteModel.fromDS(String id, Map<String,dynamic> data) {
    return TimeTableNoteModel(
      id: id,
      uid: data['uid'],
      description: data['description'],
      noteDate: data['note_date'].toDate(),
      isDone: data['is_done'],
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "description": description,
      "note_date":noteDate,
      "is_done":isDone,
      "uid":uid,
      "id":id,
    };
  }
}