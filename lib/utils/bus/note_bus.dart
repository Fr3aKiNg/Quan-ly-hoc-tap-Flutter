import 'dart:async';

import 'package:scheduleapp/utils/model/note.dart';
import 'package:scheduleapp/utils/repository/note_repo.dart';
import 'package:scheduleapp/utils/app_constant.dart';
class NoteBUS {
  final _noteRepository = NoteRepository();

  getNotes({String query}) async {
    var result = await _noteRepository.getAllNotes(query: query);
    return result;
  }

  getNoteById(String noteId) async {
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()..start();
      var res = await _noteRepository.getNote(noteId);
      print('[Time] Query Note by ID ${noteId} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res;
    }
    else{
      var res = await _noteRepository.getNote(noteId);
      return res;
    }
  }

  addNote(Notes note) async {
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()
        ..start();
      //if(note.contents.isEmpty) return false;
      var rowId = await _noteRepository.insertNotes(note);
      print('[Time] Add new Note ${note.id} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return rowId;
    }else{
      //if(note.contents.isEmpty) return false;
      var rowId = await _noteRepository.insertNotes(note);
      return rowId > -1;
    }
  }
  updateNote(Notes note) async {
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()
        ..start();
      if (note.contents.isEmpty) return false;
      var res = await _noteRepository.updateNotes(note);
      print('[Time] Update Note ${note.id} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res > 0;
    }else{
      var res = await _noteRepository.updateNotes(note);
      return res > 0;
    }
  }

  deleteNoteById(String noteId) async {
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()
        ..start();
      var res = await _noteRepository.deleteNotesById(noteId);
      print('[Time] Update Note ${noteId} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res > 0;
    }else{
      var res = await _noteRepository.deleteNotesById(noteId);
      return res > 0;
    }
  }
}
