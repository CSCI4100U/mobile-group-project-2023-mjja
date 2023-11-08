import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils{
  static Future init() async{
    //set up the database
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'moneyminder.db'),
      onCreate: (db, version){
        db.execute(
            'CREATE TABLE expenses(ID INTEGER PRIMARY KEY, Name TEXT, Category TEXT, Amount REAL, Date DATE, Description TEXT)'
        );
      },
      version: 1,
    );

    print("Created DB $database");
    return database;
  }
}