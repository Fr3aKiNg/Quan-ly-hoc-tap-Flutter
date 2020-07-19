import 'dart:async';

import 'package:Educare/utils/database/database.dart';
import 'package:Educare/utils/db_commands.dart';
import 'package:Educare/utils/log_history.dart';
import 'package:Educare/utils/model/tag.dart';
import 'package:sqflite/sqflite.dart';

class RelativeDAO {
  final dbProvider = DatabaseApp.dbProvider;

  //Insert new relative
  //Return row id
  Future<int> insertRelative(String noteId, String tagId,
      {Transaction txn}) async {
    var rowId = -1;
    if (txn != null) {
      rowId = await txn.insert(
        'relatives',
        Relative.toDatabaseJson(noteId, tagId),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      LogHistory.trackLog(
          "[Relative]",
          "INSERT new relative note:" +
              noteId.toString() +
              " with tag:" +
              tagId.toString());
    } else {
      final db = await dbProvider.database;

      rowId = await db.insert(
        'relatives',
        Relative.toDatabaseJson(noteId, tagId),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      LogHistory.trackLog(
          "[Relative]",
          "INSERT new relative note:" +
              noteId.toString() +
              " with tag:" +
              tagId.toString());
    }
    return rowId;
  }

  //Insert list relative from tag list and noteId
  //Return none
  Future<void> insertRelativesFromTagList(String noteId, List<Tag> tags,
      {Transaction txn}) async {
    if(tags.isEmpty) return;
    for (var tag in tags) {
      await insertRelative(noteId, tag.id, txn: txn);
    }
  }

  //Delete Relative Record
  //Return number of record was applied
  Future<int> deleteRelative(String noteId, String tagId) async {
    final db = await dbProvider.database;

    var count = await db.delete(
      'relatives',
      where: "note_id = ? and tag_id = ?",
      whereArgs: [noteId, tagId],
    );
    LogHistory.trackLog(
        "[Relative]",
        "DELETE relative note:" +
            noteId.toString() +
            " with tag:" +
            tagId.toString());
    return count;
  }

  //Delete Relative Record by TagId
  //Return number of record was applied
  Future<int> deleteRelativesByTagID(String tagId, {Transaction txn}) async {
    var count = 0;
    if (txn != null) {
      count = await txn.delete(
        'relatives',
        where: "tag_id = ?",
        whereArgs: [tagId],
      );
      LogHistory.trackLog(
          "[Relative]", "DELETE all relative of tag:" + tagId.toString());
    }
    else {
      final db = await dbProvider.database;
      count = await db.delete(
        'relatives',
        where: "tag_id = ?",
        whereArgs: [tagId],
      );
      LogHistory.trackLog(
          "[Relative]", "DELETE all relative of tag:" + tagId.toString());
    }
    return count;
  }

  //Delete Relative Record by NoteId
  //Return number of record was applied
  Future<int> deleteRelativesByNoteID(String noteId,{Transaction txn}) async {
    var count = 0;
    if(txn != null){
      count = await txn.delete(
        'relatives',
        where: "note_id = ?",
        whereArgs: [noteId],
      );
      LogHistory.trackLog(
          "[Relative]", "DELETE all relative of note:" + noteId.toString());
    }
    else {
      final db = await dbProvider.database;
      count = await db.delete(
        'relatives',
        where: "note_id = ?",
        whereArgs: [noteId],
      );
      LogHistory.trackLog(
          "[Relative]", "DELETE all relative of note:" + noteId.toString());
    }
    return count;
  }

  //Delete All Relative Record
  //Return number of record was applied
  Future<int> deleteAllRelatives({Transaction txn}) async {
    var count = 0;
    if(txn!= null){
      count = await txn.delete('relatives');
      LogHistory.trackLog("[Relative]", "DELETE all relative");
    }
    else {
      final db = await dbProvider.database;
      count = await db.delete('relatives');
      LogHistory.trackLog("[Relative]", "DELETE all relative");
    }
    return count;
  }

  //Get Relative by NoteID
  //Return List Relative object or null
  Future<List<Relative>> getRelativesByNoteID(String noteId) async {
    final db = await dbProvider.database;

    // Query the table for all The NoteItem of identify Note.
    final List<Map<String, dynamic>> maps =
        await db.query('relatives', where: "note_id = ?", whereArgs: [noteId]);
    List<Relative> note = maps.isNotEmpty
        ? maps.map((item) => Relative.fromDatabaseJson(item)).toList()
        : [];
    return note;
  }

  //Get Relative by TagID
  //Return List Relative object or null
  Future<List<Relative>> getRelativesByTagID(String tagId) async {
    final db = await dbProvider.database;

    // Query the table for all The NoteItem of identify Note.
    final List<Map<String, dynamic>> maps =
        await db.query('relatives', where: "tag_id = ?", whereArgs: [tagId]);
    List<Relative> note = maps.isNotEmpty
        ? maps.map((item) => Relative.fromDatabaseJson(item)).toList()
        : [];
    return note;
  }

  Future<int> getCounts() async {
    final db = await dbProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(COUNT, ['relatives']));
    return count;
  }
}

class Relative {
  String noteId;
  String tagId;

  Relative(this.noteId, this.tagId);

  factory Relative.fromDatabaseJson(Map<String, dynamic> data) =>
      Relative(data['note_id'], data['tag_id']);

  static Map<String, dynamic> toDatabaseJson(String noteId, String tagId) {
    return {'note_id': noteId, 'tag_id': tagId};
  }

  String toString() {
    return "<Relative Note_id=\"" +
        noteId.toString() +
        "\" Tag_id=\"" +
        tagId.toString() +
        "\"/>";
  }
}
