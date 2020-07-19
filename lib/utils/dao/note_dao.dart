import 'dart:async';

import 'package:note_app/utils/dao/noteItem_dao.dart';
import 'package:note_app/utils/dao/relative_dao.dart';
import 'package:note_app/utils/dao/tag_dao.dart';
import 'package:note_app/utils/dao/thumbnail_dao.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/db_commands.dart';
import 'package:note_app/utils/model/note.dart';
import 'package:sqflite/sqflite.dart';

import '../log_history.dart';

class NoteDAO {
  final dbProvider = DatabaseApp.dbProvider;
  final tagDao = TagDAO();
  final thumbnailNoteDao = ThumbnailNoteDAO();
  final noteItemDao = NoteItemDAO();
  final relativeDao = RelativeDAO();

  //Insert new Note
  //Return row id
  Future<int> createNote(Notes note) async {
    final db = await dbProvider.database;
    var noteId = -1;

    await db.transaction((txn) async {
      noteId = await txn.insert(
        'notes',
        note.toDatabaseJson(),
        //conflictAlgorithm: ConflictAlgorithm.replace,
      );
      //Insert NoteItem
      await noteItemDao.createListNoteItemByNote(note, txn: txn);
      //Insert Tag Relative
      await relativeDao.insertRelativesFromTagList(note.id, note.tags,
          txn: txn);
      //Insert Thumbnail
      await thumbnailNoteDao.createThumbnailByNote(note, txn: txn);

      LogHistory.trackLog("[Transaction][Note]", "INSERT new note:" + note.id.toString());
    });
    return noteId;
  }

  //Update a Note
  //Return number of record was applied
  Future<int> updateNote(Notes note) async {
    final db = await dbProvider.database;
    var count = 0;
    await db.transaction((txn) async {
      count = await txn.update(
        'notes',
        note.toDatabaseJson(),
        where: "note_id = ?",
        whereArgs: [note.id],
      );

      await relativeDao.deleteRelativesByNoteID(note.id, txn: txn);
      await relativeDao.insertRelativesFromTagList(note.id, note.tags,
          txn: txn);
      await noteItemDao.deleteNoteItemsByNoteID(note.id,txn: txn);
      await noteItemDao.createListNoteItemByNote(note,txn: txn);

//      await noteItemDao.updateListNoteItemByNote(note, txn: txn);
      await thumbnailNoteDao.updateThumbnailByNote(note,txn: txn);

      LogHistory.trackLog("[Transaction][Note]", "UPDATE note:" + note.id.toString());
    });

    return count;
  }

  //Delete Note Record
  //Return number of record was applied
  Future<int> deleteNote(String noteId) async {
    final db = await dbProvider.database;
    var count = 0;
    await db.transaction((txn) async {
      count =
          await txn.delete('notes', where: "note_id = ?", whereArgs: [noteId]);

      await relativeDao.deleteRelativesByNoteID(noteId, txn: txn);
      await noteItemDao.deleteNoteItemsByNoteID(noteId, txn: txn);

      await thumbnailNoteDao.deleteThumbnail(noteId, txn: txn);
      LogHistory.trackLog("[Transaction][Note]", "DELETE note:" + noteId.toString());
    });
    return count;
  }

  //Delete All Note Record
  //Return number of record was applied
  Future<int> deleteAllNotes() async {
    final db = await dbProvider.database;
    var count = 0;
    await db.transaction((txn) async {
      await txn.delete(
        'notes',
      );
      await noteItemDao.deleteAllNoteItem(txn: txn);
      await relativeDao.deleteAllRelatives(txn: txn);
      //await tagDao.deleteAllTags();

      LogHistory.trackLog("[Transaction][Note]", "DELETE ALL note");
    });
    return count;
  }

  //Get All Note
  //Searches if query string was passed
  //TODO
  Future<List<Notes>> getNotes({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query('notes',
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query('notes', columns: columns);
    }

    List<Notes> note = result.isNotEmpty
        ? result.map((item) => Notes.fromDatabaseJson(item)).toList()
        : [];
    return note;
  }

  Future<List<Notes>> getNotesFullData({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query('notes',
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query('notes', columns: columns);
    }

    List<Notes> notes = new List<Notes>();
    for(var i in result){
      notes.add(await getNoteByID(i['note_id']));
    }
    return notes;
  }

  //Get Note by ID
  //Return note object or null
  Future<Notes> getNoteByID(String noteId) async {
    final db = await dbProvider.database;
    // Get List Note
    List<Map<String, dynamic>> maps =
        await db.query('notes', where: "note_id = ?", whereArgs: [noteId]);
    // Case Found
    if (maps.isNotEmpty) {
      var tags = await tagDao.getTagsByNoteID(noteId); //Get tags of Note
      var noteItems = await noteItemDao
          .getNoteItemsByNoteID(noteId); //Get noteItems of Note
      var note = Notes.fromDatabaseJson(maps.first); //Create base Note
      note.setTag(tags);
      note.setListNoteItems(noteItems);

      return note;
    }
    return null;
  }

//  Future<int> updateOrder(int order) async {
//    final db = await dbProvider.database;
//
//    var orderId = await db.insert(
//      'tableCount',
//      {'id': 'notes', 'count': order},
//      conflictAlgorithm: ConflictAlgorithm.replace,
//    );
//    return orderId;
//  }
//
//  Future<int> getOrder() async {
//    final db = await dbProvider.database;
//    List<Map<String, dynamic>> maps =
//        await db.query('tableCount', where: "id = ?", whereArgs: ["notes"]);
//    if (maps.isNotEmpty)
//      return maps[0]['count'];
//    else
//      return 0;
//  }

  Future<int> getCounts() async {
    final db = await dbProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(COUNT, ['notes']));
    return count;
  }
}
