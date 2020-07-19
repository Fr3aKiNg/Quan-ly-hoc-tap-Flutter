import 'package:note_app/utils/dao/note_dao.dart';
import 'package:note_app/utils/model/note.dart';

class NoteRepository {
  final noteDao = NoteDAO();

  Future getAllNotes({String query}) => noteDao.getNotes(query: query);

  Future getNote(String id) => noteDao.getNoteByID(id);

  Future insertNotes(Notes note) => noteDao.createNote(note);
  Future updateNotes(Notes note) => noteDao.updateNote(note);

  Future deleteNotesById(String id) => noteDao.deleteNote(id);

  //We are not going to use this in the demo
  Future deleteAllNotes() => noteDao.deleteAllNotes();
}