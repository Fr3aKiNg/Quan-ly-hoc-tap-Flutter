import 'package:firebase_helpers/firebase_helpers.dart';

class TimeTableNoteModel extends DatabaseItem{
  final String id;
  final String description;
  final DateTime noteDate;
  final bool isDone;

  TimeTableNoteModel({this.id,this.description, this.noteDate, this.isDone}):super(id);

  factory TimeTableNoteModel.fromMap(Map data) {
    return TimeTableNoteModel(
      description: data['description'],
      noteDate: data['note_date'],
      isDone: data['is_done'],
    );
  }

  factory TimeTableNoteModel.fromDS(String id, Map<String,dynamic> data) {
    return TimeTableNoteModel(
      id: id,
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
      "id":id,
    };
  }
}