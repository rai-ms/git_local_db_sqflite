import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class DatabaseHelper
{
  /// Database Name
  static const DATABASE_NAME = "mydatabase.db";

  /// Database Version
  static const DATABASE_VERSION = 1;

  /// Notes Table
  static const TABLE_NOTES = "notes_table";
  static const USER_NOTES = "notes_table_user";

  /// Notes Table Contents
  static const NOTES_ID = 'id', NOTES_TEXT = 'text';

  /// Creating the instance of the database which helps to get the same instance in any page within the app
  static final DatabaseHelper getInstance = DatabaseHelper();

  /// Database Initialization
  static Database? _database;

  Future get database async {
    return _database ??= await initDB();
  }

  /// Initialization of Database
  Future initDB() async{
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = join(appDocumentsDir.path, DATABASE_NAME);

    /// Creation of Table in database
           // await openDatabase(path, version: DATABASE_VERSION, onCreate: onCreate);
    return await openDatabase(path, version: DATABASE_VERSION, onCreate: onCreate);
  }

  /// Creating the table notes_table which contains Id and Text of each notes
  Future onCreate(Database database, int version) async {
    database.execute(
        ''' 
            CREATE TABLE $TABLE_NOTES 
            (
              $NOTES_ID INTEGER PRIMARY KEY,
              $NOTES_TEXT TEXT NOT NULL
            )
        '''
    );
  }
  // /// Creating the table notes_table which contains Id and Text of each notes
  // Future onCreate2(Database database, int version) async {
  //   database.execute(
  //       '''
  //           CREATE TABLE $USER_NOTES
  //           (
  //             $NOTES_ID INTEGER PRIMARY KEY,
  //             $NOTES_TEXT TEXT NOT NULL
  //           )
  //       '''
  //   );
  // }

  /// Insertion in  Table
  Future insertDatabase(Map<String, dynamic> rowNotes) async
  {
    Database db = await getInstance.database;
    return await db.insert(TABLE_NOTES, rowNotes);
  }

  /// Read from Table
  Future<List<Map<String, dynamic>>> queryDatabase () async
  {
    Database db = await getInstance.database;
    return await db.query(TABLE_NOTES);
  }

  /// Update from Table
  Future<int> updateDatabase (Map<String, dynamic> rowNotes) async
  {
    Database db = await getInstance.database;

    int id = rowNotes[NOTES_ID];

    return db.update(TABLE_NOTES, rowNotes, whereArgs: [id]);
  }

  /// Delete from Table
  Future<int> deleteDatabase (int id) async
  {
    Database db = await getInstance.database;

    return db.delete(TABLE_NOTES,where: '$NOTES_ID', whereArgs: [id]);
  }



}