import 'dart:async';

import 'package:Educare/utils/database/database.dart';
import 'package:Educare/utils/db_commands.dart';
import 'package:Educare/utils/log_history.dart';
import 'package:Educare/utils/model/note.dart';
import 'package:Educare/utils/model/noteItem.dart';
import 'package:sqflite/sqflite.dart';

class NoteItemDAO {
  final dbProvider = DatabaseApp.dbProvider;

  //Insert NoteItem with note ID
  //Return row id
  Future<int> createNoteItem(NoteItem noteItem, String noteId,
      {Transaction txn}) async {
    var noteItemId = -1;
    if (txn != null) {
      noteItemId = await txn.insert('noteItems', noteItem.toDatabaseJson(noteId)
          //conflictAlgorithm: ConflictAlgorithm.replace,
          );
      LogHistory.trackLog(
          "[NoteItem]",
          "INSERT new notItem:" +
              noteItem.id.toString() +
              " of note: " +
              noteId.toString());
    } else {
      final db = await dbProvider.database;
      noteItemId = await db.insert('noteItems', noteItem.toDatabaseJson(noteId)
          //conflictAlgorithm: ConflictAlgorithm.replace,
          );
      LogHistory.trackLog(
          "[NoteItem]",
          "INSERT new notItem:" +
              noteItem.id.toString() +
              " of note: " +
              noteId.toString());
    }
    return noteItemId;
  }

  //Insert ListNoteItem by note
  //Return none
  Future<void> createListNoteItemByNote(Notes note, {Transaction txn}) async {
    if(note.contents.isEmpty) return;
    for (var noteItem in note.contents) {
      await createNoteItem(noteItem, note.id, txn: txn);
    }
  }

  //Update List NoteItem with noteItem
  //Return number of record was applied
  Future<void> updateListNoteItemByNote(Notes note, {Transaction txn}) async {
    for (var noteItem in note.contents) {
      await updateNoteItem(noteItem, txn: txn);
    }
  }

  Future<int> updateNoteItem(NoteItem noteItem, {Transaction txn}) async {
    var count = 0;
    if (txn != null) {
      count = await txn.update(
        'noteItems',
        noteItem.toDatabaseJsonWithOutNoteID(),
        // Ensure that the NoteItem has a matching id.
        where: "noteItem_id = ?",
        // Pass the NoteItem's id as a whereArg to prevent SQL injection.
        whereArgs: [noteItem.id],
      );
      LogHistory.trackLog(
          "[NoteItem]", "UPDATE noteItem:" + noteItem.id.toString());
    } else {
      final db = await dbProvider.database;
      // Update the given NoteItem.
      count = await db.update(
        'noteItems',
        noteItem.toDatabaseJsonWithOutNoteID(),
        // Ensure that the NoteItem has a matching id.
        where: "noteItem_id = ?",
        // Pass the NoteItem's id as a whereArg to prevent SQL injection.
        whereArgs: [noteItem.id],
      );
      LogHistory.trackLog(
          "[NoteItem]", "UPDATE noteItem:" + noteItem.id.toString());
    }
    return count;
  }

  //Delete NoteItem
  //Return number of record was applied
  Future<int> deleteNoteItem(String noteItemId,{Transaction txn}) async {
    var count = 0;
    if(txn!= null){
      count = await txn.delete(
        'noteItems',
        // Use a `where` clause to delete a specific NoteItem.
        where: "noteItem_id = ?",
        // Pass the NoteItem's id as a whereArg to prevent SQL injection.
        whereArgs: [noteItemId],
      );
      LogHistory.trackLog(
          "[NoteItem]", "DELETE noteItem:" + noteItemId.toString());
    }
    else {
      final db = await dbProvider.database;
      // Remove the NoteItem from the database.
      count = await db.delete(
        'noteItems',
        // Use a `where` clause to delete a specific NoteItem.
        where: "noteItem_id = ?",
        // Pass the NoteItem's id as a whereArg to prevent SQL injection.
        whereArgs: [noteItemId],
      );
      LogHistory.trackLog(
          "[NoteItem]", "DELETE noteItem:" + noteItemId.toString());
    }
    return count;
  }

  //Delete NoteItem by NoteID
  //Return number of record was applied
  Future<void> deleteNoteItemsByNoteID(String noteId, {Transaction txn}) async {
    var count = 0;
    if (txn != null) {
      count = await txn.delete(
        'noteItems',
        // Use a `where` clause to delete a specific NoteItem.
        where: "note_id = ?",
        // Pass the NoteItem's id as a whereArg to prevent SQL injection.
        whereArgs: [noteId],
      );
      LogHistory.trackLog(
          "[NoteItem]", "DELETE noteItems by note id:" + noteId.toString());
    } else {
      final db = await dbProvider.database;

      // Remove the NoteItem from the database.
      count = await db.delete(
        'noteItems',
        // Use a `where` clause to delete a specific NoteItem.
        where: "note_id = ?",
        // Pass the NoteItem's id as a whereArg to prevent SQL injection.
        whereArgs: [noteId],
      );
      LogHistory.trackLog(
          "[NoteItem]", "DELETE noteItems by note id:" + noteId.toString());
    }
    return count;
  }

  //Delete All NoteItem
  //Return number of record was applied
  Future<void> deleteAllNoteItem({Transaction txn}) async {
    var count = 0;
    if (txn != null) {
      count = await txn.delete('noteItems');
      LogHistory.trackLog("[NoteItem]", "DELETE All noteItem");
    } else {
      final db = await dbProvider.database;
      //  // Remove the NoteItem from the database.
      count = await db.delete('noteItems');
      LogHistory.trackLog("[NoteItem]", "DELETE All noteItem");
    }

    return count;
  }

  //Get Single NoteItem
  //Return NoteItem object or null
  Future<NoteItem> getNoteItem(String noteId) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps =
        await db.query('notes', where: "noteItem_id = ?", whereArgs: [noteId]);

    return maps.isEmpty ? null : NoteItem.fromDatabaseJson(maps.first);
  }

  //Get List NoteItem of noteId
  //Return NoteItem object or null
  Future<List<NoteItem>> getNoteItemsByNoteID(String noteId) async {
    final db = await dbProvider.database;

    // Query the table for all The NoteItem of identify Note.
    final List<Map<String, dynamic>> maps =
        await db.query('noteItems', where: "note_id = ?", whereArgs: [noteId]);

    // Convert the List<Map<String, dynamic> into a List<NoteItem>.
    List<NoteItem> note = maps.isNotEmpty
        ? maps.map((item) => NoteItem.fromDatabaseJson(item)).toList()
        : [];
    return note;
  }

  Future<int> updateOrder(int order) async {
    final db = await dbProvider.database;

    var orderId = await db.insert(
      'tableCount',
      {'id': 'noteItems', 'count': order},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return orderId;
  }

  Future<int> getOrder() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> maps =
        await db.query('tableCount', where: "id = ?", whereArgs: ["noteItems"]);
    if (maps.isNotEmpty)
      return maps[0]['count'];
    else
      return 0;
  }

  Future<int> getCounts() async {
    final db = await dbProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(COUNT, ['noteItems']));
    return count;
  }
}
