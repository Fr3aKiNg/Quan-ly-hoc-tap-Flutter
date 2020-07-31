import 'dart:async';

import 'package:scheduleapp/utils/database/database.dart';
import 'package:scheduleapp/utils/db_commands.dart';
import 'package:scheduleapp/utils/model/note.dart';
import 'package:sqflite/sqflite.dart';

import '../log_history.dart';

class NoteDAO {
  final dbProvider = DatabaseApp.dbProvider;

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
    if (maps.isNotEmpty) {//Get noteItems of Note
      var note = Notes.fromDatabaseJson(maps.first); //Create base Note

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
