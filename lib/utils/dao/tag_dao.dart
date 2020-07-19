import 'dart:async';

import 'package:Educare/utils/dao/relative_dao.dart';
import 'package:Educare/utils/database/database.dart';
import 'package:Educare/utils/db_commands.dart';
import 'package:Educare/utils/log_history.dart';
import 'package:Educare/utils/model/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

class TagDAO {
  final dbProvider = DatabaseApp.dbProvider;
  final relativeDao = RelativeDAO();

  //Insert new Tag
  //Return row id
  Future<int> createTag(Tag tag, {Transaction txn}) async {
    final db = await dbProvider.database;
    var tagId = -1;

    if (txn != null) {
      tagId = await txn.insert('tags', tag.toDatabaseJson()
          //conflictAlgorithm: ConflictAlgorithm.abort,
          );
      LogHistory.trackLog("[TAG]", "INSERT tag:" + tag.id.toString());
    } else
      await db.transaction((txn) async {
        tagId = await txn.insert('tags', tag.toDatabaseJson()
            //conflictAlgorithm: ConflictAlgorithm.abort,
            );
        LogHistory.trackLog("[TAG]", "INSERT tag:" + tag.id.toString());
      });
    return tagId;
  }

  //Update a Tag
  //Return number of record was applied
  Future<int> updateTag(Tag tag, {Transaction txn}) async {
    var count = 0;
    if (txn != null) {
      count = await txn.update(
        'tags',
        tag.toDatabaseJson(),
        where: "tag_id = ?",
        whereArgs: [tag.id],
      );
      LogHistory.trackLog("[TAG]", "UPDATE tag:" + tag.id.toString());
    }
    else {
      final db = await dbProvider.database;
      count = await db.update(
        'tags',
        tag.toDatabaseJson(),
        where: "tag_id = ?",
        whereArgs: [tag.id],
      );
      LogHistory.trackLog("[TAG]", "UPDATE tag:" + tag.id.toString());
    }
    return count;
  }

  //Delete a Tag
  //Return number of record was applied
  Future<int> deleteTag(String tagId,{Transaction txn}) async {
    var count = 0;
    if(txn!= null){
        await relativeDao.deleteRelativesByTagID(tagId,txn:txn);
        count = await txn.delete(
          'tags',
          where: "tag_id = ?",
          whereArgs: [tagId],
        );
        LogHistory.trackLog("[TAG]", "DELETE tag:" + tagId.toString());
    }
    else {
      final db = await dbProvider.database;
      await db.transaction((txn1) async {
        await relativeDao.deleteRelativesByTagID(tagId,txn:txn1);
        count = await txn1.delete(
          'tags',
          where: "tag_id = ?",
          whereArgs: [tagId],
        );
        LogHistory.trackLog("[TAG]", "DELETE tag:" + tagId.toString());
      });
    }
    return count;
  }

  //Delete All Tag Record
  //Return number of record was applied
  Future deleteAllTags({Transaction txn}) async {
    var count = 0;

    if(txn!= null){
      await relativeDao.deleteAllRelatives(txn:txn);
      count = await txn.delete(
        'tags',
      );
      LogHistory.trackLog("[TAG]", "DELETE all tag");
    }
    else {
      final db = await dbProvider.database;
      await db.transaction((txn1) async {
        count = await txn1.delete(
          'tags',
        );
        await relativeDao.deleteAllRelatives(txn:txn1);
        LogHistory.trackLog("[TAG]", "DELETE all tag");
      });
    }
    return count;
  }

  //Get Tag by ID
  //Return Tag object or null
  Future<Tag> getTagByID(String tagId) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps =
        await db.query('tags', where: "tag_id = ?", whereArgs: [tagId]);

    if (maps.isNotEmpty) {
      return Tag.fromDatabaseJson(maps.first);
    } else
      return null;
  }

  //Get Tag by Title
  //Return Tag object or null
  Future<bool> exist(String title) async {
    final db = await dbProvider.database;
    return firstIntValue(await db.query('tags',
        columns:['COUNT(*)'],
        where: "title = ?", whereArgs: [title])) == 1;
  }

  //Get List Tag of Note
  //Return List Tag object or null
  Future<List<Tag>> getTagsByNoteID(String noteId) async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> result =
        await db.rawQuery(SELECT_TAG_RELATIVES_JOIN_TAGS, [noteId]);

    List<Tag> tags = result.isNotEmpty
        ? result.map((item) => Tag.fromDatabaseJson(item)).toList()
        : [];
    return tags;
  }

  //Get List Tag in Database
  //Return List Tag object or null
  Future<List<Tag>> getTags({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query('tags',
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query('tags', columns: columns);
    }

    List<Tag> note = result.isNotEmpty
        ? result.map((item) => Tag.fromDatabaseJson(item)).toList()
        : [];
    return note;
  }

  Future<int> getOrder() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> maps =
        await db.query('tableCount', where: "id = ?", whereArgs: ["tags"]);
    if (maps.isNotEmpty)
      return maps[0]['count'];
    else
      return 0;
  }

  Future<int> updateOrder(int order) async {
    final db = await dbProvider.database;

    var orderId = await db.insert(
      'tableCount',
      {'id': 'tags', 'count': order},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return orderId;
  }

  Future<int> getCounts() async {
    final db = await dbProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(COUNT, ['tags']));
    return count;
  }
}
