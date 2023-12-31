/// this is utility file for DB.
/// This will create a localDB and create all necessary tables for the application

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // initialize DB
  // then run all the CREATE TABLE cmd
  Future<Database> initDB() async {
    return openDatabase(
      path.join(await getDatabasesPath(), 'money_minder_local.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS login(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          emailAddress TEXT,
          password TEXT
          )
        ''');
        db.execute('''
         CREATE TABLE IF NOT EXISTS signup(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            emailAddress TEXT,
            fullName TEXT,
            username TEXT,
            password TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE IF NOT EXISTS goal(
              id INTEGER PRIMARY KEY,
              name TEXT,
              description TEXT,
              amount REAL,
              endDate TEXT,
              isCompleted INTEGER
            )
        ''');
        db.execute('''
          CREATE TABLE IF NOT EXISTS reminder(
              id INTEGER PRIMARY KEY,
              title TEXT,
              description TEXT,
              endDate TEXT,
              isCompleted INTEGER, 
              isUrgent INTEGER
            )
        ''');
      },
      version: 1,
    );
  }
}
