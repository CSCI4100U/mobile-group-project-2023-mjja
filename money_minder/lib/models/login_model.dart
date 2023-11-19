/**
 * LoginDatabase: This class contains all the method realted to Login class
 */

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/localDB/login.dart';
import '../data/localDB/db_utils.dart';

class LoginDatabase {
  final dbUtils = DBUtils();

  // initialize database and create table if does not exists
  Future<void> initializeDatabase() async {
    try {
      final db = await dbUtils.database;
      await db.execute('''
      CREATE TABLE IF NOT EXISTS login(
        id INTEGER PRIMARY KEY,
        emailAddress TEXT,
        password TEXT
      )
    ''');
    } catch (e) {
      print('Error initializing the database: $e');
    }
  }

  // create a new login record
  Future<int?> createLogin(Login login) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.insert('login', login.toMap());
  }

  // read login records
  Future<List<Login>> readLogin() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query('login');
    return List.generate(maps!.length, (i) {
      return Login.fromMap(maps[i]);
    });
  }

  // update login record by id
  Future<int?> updateLogin(Login login) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.update(
      'login',
      login.toMap(),
      where: 'id = ?',
      whereArgs: [login.id], // Assuming there is only one login entry
    );
  }

  // delete login record by id
  Future<int?> deleteLogin(int id) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.delete('login', where: 'id = ?', whereArgs: [id]);
  }

  // check if the login record already exists
  Future<bool> checkLoginCredentials(
      String emailAddress, String password) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query(
      'login',
      where: 'emailAddress = ? AND password = ?',
      whereArgs: [emailAddress, password],
    );

    return maps != null && maps.isNotEmpty;
  }
}
