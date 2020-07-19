import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db_commands.dart';
import '../model/tag.dart';

class DatabaseApp {
  // Open the database and store the reference.
  static final DatabaseApp dbProvider = DatabaseApp();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }
  closeDb() async {
    if(_database != null) await _database.close();
  }
  static closeDatabase() async {
    final dbProvider = DatabaseApp.dbProvider;
    await dbProvider.closeDb();
  }
  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test59.db");
    print(path);
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }
  void initDB(Database database, int version) async {
    print("INIT NEW DATABASE");
//    await database.execute(DROP_TABLE_NOTE);
//    await database.execute(DROP_TABLE_TAG);
//    await database.execute(DROP_TABLE_NOTE_ITEM);
//    await database.execute(DROP_TABLE_RELATIVE);
//    await database.execute(DROP_TABLE_THUMBNAIL);

    await database.execute(CREATE_TABLE_RELATIVE);
    await database.execute(CREATE_TABLE_THUMBNAIL_NOTE);
    await database.execute(CREATE_TABLE_TAG);
    await database.execute(CREATE_TABLE_NOTE_ITEM);
    await database.execute(CREATE_TABLE_NOTE);

  }
  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }
}
