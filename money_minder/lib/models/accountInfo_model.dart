/**
 * AccountInfoDatabase: This class contains all the method realted to accountInfo class
 */

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/localDB/accountInfo.dart';
import '../data/localDB/db_utils.dart';

class AccountInfoDatabase {
  final dbUtils = DBUtils();

  // initialize database and create table if does not exists
  Future<void> initializeDatabase() async {
    try {
      final db = await dbUtils.database;
      await db.execute('''
        CREATE TABLE IF NOT EXISTS accountInfo(
            id INTEGER PRIMARY KEY,
            emailAddress TEXT,
            fullName TEXT,
            username TEXT,
            password TEXT
          )
        ''');
    } catch (e) {
      print('Error initializing the database: $e');
    }
  }

  // create a new accountInfo record
  Future<int?> createAccountInfo(AccountInfo accountInfo) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.insert('accountInfo', accountInfo.toMap());
  }

  // read accountInfo records
  Future<List<AccountInfo>> readAccountInfo() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query('accountInfo');
    return List.generate(maps!.length, (i) {
      return AccountInfo.fromMap(maps[i]);
    });
  }

  // update accountInfo record by id
  Future<int?> updateAccountInfo(AccountInfo accountInfo) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.update(
      'accountInfo',
      accountInfo.toMap(),
      where: 'id = ?',
      whereArgs: [accountInfo.id], // Assuming there is only one account info entry
    );
  }

  // delete accountInfo record by id
  Future<int?> deleteAccountInfo(int id) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.delete(
      'accountInfo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}