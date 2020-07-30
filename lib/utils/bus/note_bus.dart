import 'dart:async';

import 'package:scheduleapp/utils/model/note.dart';
import 'package:scheduleapp/utils/app_constant.dart';
import 'package:scheduleapp/utils/dao/note_dao.dart';
class NoteBUS {
  final _noteDao = NoteDAO();

  getNotes({String query}) async {
    var result = await _noteDao.getNotes(query: query);
    return result;
  }

  getNoteById(String noteId) async {
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()..start();
      var res = await _noteDao.getNoteByID(noteId);
      print('[Time] Query Note by ID ${noteId} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res;
    }
    else{
      var res = await _noteDao.getNoteByID(noteId);
      return res;
    }
  }

  addNote(Notes note) async {
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()
        ..start();
      //if(note.contents.isEmpty) return false;
      var rowId = await _noteDao.createNote(note);
      print('[Time] Add new Note ${note.id} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return rowId;
    }else{
      //if(note.contents.isEmpty) return false;
      var rowId = await _noteDao.createNote(note);
      return rowId > -1;
    }
  }
  updateNote(Notes note) async {
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()
        ..start();
      if (note.contents.isEmpty) return false;
      var res = await _noteDao.updateNote(note);
      print('[Time] Update Note ${note.id} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res > 0;
    }else{
      var res = await _noteDao.updateNote(note);
      return res > 0;
    }
  }

  deleteNoteById(String noteId) async {
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()
        ..start();
      var res = await _noteDao.deleteNote(noteId);
      print('[Time] Update Note ${noteId} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res > 0;
    }else{
      var res = await _noteDao.deleteNote(noteId);
      return res > 0;
    }
  }
  deleteAllNote() async{
    var res = await _noteDao.deleteAllNotes();
  }
}
