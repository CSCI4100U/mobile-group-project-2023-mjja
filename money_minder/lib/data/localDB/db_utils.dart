/**
 * this is utility file for DB.
 * This will create a localDB and all create necessary tables for the application
 */

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
         CREATE TABLE IF NOT EXISTS signup(
            id INTEGER PRIMARY KEY,
            emailAddress TEXT,
            fullName TEXT,
            username TEXT,
            password TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE IF NOT EXISTS login(
          id INTEGER PRIMARY KEY,
          emailAddress TEXT,
          password TEXT
          )
        ''');
        db.execute('''
            CREATE TABLE IF NOT EXISTS accountInfo(
            id INTEGER PRIMARY KEY,
            emailAddress TEXT,
            firstName TEXT,
            lastName TEXT,
            phoneNumber TEXT
          )
        ''');
        db.execute('''
         CREATE TABLE IF NOT EXISTS expenses(
              id INTEGER PRIMARY KEY,
              name TEXT,
              category TEXT,
              amount REAL,
              date TEXT,
              description TEXT
            )
        ''');
      },
      version: 1,
    );
  }
}
