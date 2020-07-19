import 'dart:async';
import 'dart:collection';

import 'package:note_app/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_app/utils/dao/tag_dao.dart';
import 'package:note_app/utils/db_commands.dart';
import 'package:note_app/utils/model/note.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';
import '../log_history.dart';

class ThumbnailNoteDAO {
  final dbProvider = DatabaseApp.dbProvider;
  final tagDao = TagDAO();

  //Insert new Thumbnail
  //Return row id
  Future<int> createThumbnail(ThumbnailNote thumbnail,
      {Transaction txn}) async {
    var thumbId = -1;
    if (txn != null) {
      thumbId = await txn.insert(
        'thumbnails',
        thumbnail.toDatabaseJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      LogHistory.trackLog("[Transaction][Thumbnail]",
          "INSERT new thumbnail note:" + thumbnail.noteId.toString());
    } else {
      final db = await dbProvider.database;
      thumbId = await db.insert(
        'thumbnails',
        thumbnail.toDatabaseJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      LogHistory.trackLog("[Thumbnail]",
          "INSERT new thumbnail note:" + thumbnail.noteId.toString());
    }
    return thumbId;
  }

  //Insert new Thumbnail
  //Return row id
  Future<int> createThumbnailByNote(Notes note, {Transaction txn}) async {
    String content = EMPTY_NOTE;
    String type = DEFAULT_TYPE;
    Color color = DEFAULT_ITEM_COLOR;

    if(note.contents.isNotEmpty){
      type = note.contents[0].type;
      color = note.contents[0].noteColor;
      content = note.contents[0].content;
    }
    ThumbnailNote thumbnail = new ThumbnailNote(
        note.id,
        note.title,
        note.tags,
        type,
        color,
        content,
        note.created_time,
        note.modified_time);
    var thumbId = -1;
    if (txn != null) {
      thumbId = await txn.insert(
        'thumbnails',
        thumbnail.toDatabaseJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      LogHistory.trackLog("[Transaction][Thumbnail]",
          "INSERT new thumbnail note:" + thumbnail.noteId.toString());
    } else {
      final db = await dbProvider.database;
      thumbId = await db.insert(
        'thumbnails',
        thumbnail.toDatabaseJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      LogHistory.trackLog("[Thumbnail]",
          "INSERT new thumbnail note:" + thumbnail.noteId.toString());
    }
    return thumbId;
  }

  //Get Thumbnail by noteID
  //Return Thumbnail object or null
  Future<ThumbnailNote> getThumbnailByID(String noteId) async {
    final db = await dbProvider.database;
    // Get List Note
    List<Map<String, dynamic>> maps =
        await db.query('thumbnails', where: "note_id = ?", whereArgs: [noteId]);
    // Case Found
    if (maps.isNotEmpty) {
      var tags = await tagDao.getTagsByNoteID(noteId);
      var result = ThumbnailNote.fromDatabaseJson(maps.first);
      result.setTag(tags);
      return result;
    } else
      return null;
  }

  //Get all Thumbnails
  //Return List Thumbnail object or null
  Future<List<ThumbnailNote>> getThumbnails(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query('thumbnails',
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query('thumbnails', columns: columns);
    }

    if (result.isNotEmpty) {
      List<ThumbnailNote> thumbs =
          result.map((item) => ThumbnailNote.fromDatabaseJson(item)).toList();
      for (var thumb in thumbs) {
        var tags = await tagDao.getTagsByNoteID(thumb.noteId);
        thumb.setTag(tags);
      }
      return thumbs;
    } else
      return [];
  }
  Future<ThumbnailNote> getThumbnailByIDWithTag(String noteId,String tagId) async {
    final db = await dbProvider.database;
    // Get List Note
    List<Map<String, dynamic>> maps =
    await db.query('thumbnails', where: "note_id = ?", whereArgs: [noteId]);
    // Case Found
    if (maps.isNotEmpty) {
      var tags = await tagDao.getTagsByNoteID(noteId);
      for(var i in tags){
        if(i.id == tagId){
          tags.remove(i);
          tags.insert(0,i);
          break;
        }
      }
      var result = ThumbnailNote.fromDatabaseJson(maps.first);
      result.setTag(tags);
      return result;
    } else
      return null;
  }
  Future<List<ThumbnailNote>> findThumbnailByTagId(String tagId) async {
    final db = await dbProvider.database;
    //Using full text search sql table Note
    final List<Map<String, dynamic>> notes =
        await db.rawQuery(SELECT_THUMBNAILS_BY_TAGID, [tagId]);

    if (notes.isNotEmpty) {
      List<ThumbnailNote> thumbs = new List<ThumbnailNote>();
      for (var note in notes) {
        var thumb = await getThumbnailByIDWithTag(note['note_id'],tagId);
        thumbs.add(thumb);
      }
      return thumbs;
    } else
      return [];
  }

  //Get all Thumbnails that Note contain keyword
  //FULL TEXT SEARCH
  //Return List Thumbnail object or null
  Future<List<ThumbnailNote>> findThumbnailByKeyWord(String keyword) async {
    final db = await dbProvider.database;
    //Using full text search sql table Note
    final List<Map<String, dynamic>> notes =
        await db.rawQuery(FTS_NOTE + keyword + "*\'");

    if (notes.isNotEmpty) {
      List<ThumbnailNote> thumbs = new List<ThumbnailNote>();
      for (var note in notes) {
        var thumb = await getThumbnailByID(note['note_id']);
        thumbs.add(thumb);
      }
      return thumbs;
    } else
      return [];
  }

  //Get all Thumbnails that Note contain keyword in title and content
  //FULL TEXT SEARCH
  //Return List Thumbnail object or null
  Future<List<ThumbnailNote>> findThumbnailByKeyWordAll(String keyword) async {
    final db = await dbProvider.database;
    //Using full text search sql table Note
    final List<Map<String, dynamic>> notes =
        await db.rawQuery(FTS_NOTE + keyword + "*\'");

    final List<Map<String, dynamic>> noteItems =
        await db.rawQuery(FTS_NOTE_ITEM + keyword + "*\'");

    if (noteItems.isNotEmpty || notes.isNotEmpty) {
      List<String> noteIdList = new List<String>();
      for (var note in notes) {
        noteIdList.add(note['note_id']);
      }
      for (var noteItem in noteItems) {
        noteIdList.add(noteItem['note_id']);
      }
      List<String> res = LinkedHashSet<String>.from(noteIdList).toList();

      List<ThumbnailNote> thumbs = new List<ThumbnailNote>();
      for (var noteId in res) {
        var thumb = await getThumbnailByID(noteId);
        thumbs.add(thumb);
      }
      return thumbs;
    } else
      return [];
  }

  //Delete All Thumbnail Record
  //Return number of record was applied
  Future deleteAllThumbnails() async {
    final db = await dbProvider.database;
    var count = await db.delete('thumbnails');
    LogHistory.trackLog("[Thumbnail]", "DELETE All thumbnail");
    return count;
  }

  //Delete Thumbnail Record by NoteId
  //Return number of record was applied
  Future<int> deleteThumbnail(String noteId, {Transaction txn}) async {
    var count = 0;
    if (txn != null) {
      count = await txn
          .delete('thumbnails', where: "note_id = ?", whereArgs: [noteId]);
      LogHistory.trackLog(
          "[Transaction][Thumbnail]", "DELETE thumbnail of note: " + noteId.toString());
      return count;
    } else {
      final db = await dbProvider.database;
      count = await db
          .delete('thumbnails', where: "note_id = ?", whereArgs: [noteId]);
      LogHistory.trackLog(
          "[Thumbnail]", "DELETE thumbnail of note: " + noteId.toString());
      return count;
    }
  }

  //Update a Thumbnail
  //Return number of record was applied
  Future<int> updateThumbnail(ThumbnailNote thumbnail) async {
    final db = await dbProvider.database;
    var count = await db.update(
      'thumbnails',
      thumbnail.toDatabaseJson(),
      where: "note_id = ?",
      whereArgs: [thumbnail.noteId],
    );
    LogHistory.trackLog(
        "[Note]", "UPDATE thumbnail of note:" + thumbnail.noteId.toString());
    return count;
  }

  //Update a Thumbnail by noteid
  //Return number of record was applied
  Future<int> updateThumbnailByNote(Notes note, {Transaction txn}) async {
    ThumbnailNote thumbnail = new ThumbnailNote(
        note.id,
        note.title,
        note.tags,
        note.contents[0].type,
        note.contents[0].noteColor,
        note.contents[0].content,
        note.created_time,
        note.modified_time);
    var count = 0;
    if (txn != null) {
      count = await txn.update(
        'thumbnails',
        thumbnail.toDatabaseJson(),
        where: "note_id = ?",
        whereArgs: [thumbnail.noteId],
      );
      LogHistory.trackLog(
          "[Transaction][Thumbnail]", "UPDATE thumbnail of note:" + thumbnail.noteId.toString());
    } else {
      final db = await dbProvider.database;
      count = await db.update(
        'thumbnails',
        thumbnail.toDatabaseJson(),
        where: "note_id = ?",
        whereArgs: [thumbnail.noteId],
      );
      LogHistory.trackLog(
          "[Thumbnail]", "UPDATE thumbnail of note:" + thumbnail.noteId.toString());
    }
    return count;
  }

  Future<int> getCounts() async {
    final db = await dbProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(COUNT, ['thumbnails']));
    return count;
  }
}
