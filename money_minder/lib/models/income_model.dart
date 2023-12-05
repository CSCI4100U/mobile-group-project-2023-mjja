/**
 * IncomeDatabase: This class contains all the method related to Income class
 */

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/localDB/db_utils.dart';
import '../data/localDB/income.dart';

class IncomeDatabase {
  final dbUtils = DBUtils();

  // initialize database and create table if does not exists
  Future<void> initializeDatabase() async {
    try {
      final db = await dbUtils.database;
      await db.execute('''
      CREATE TABLE IF NOT EXISTS income(
              id INTEGER PRIMARY KEY,
              name TEXT,
              amount REAL,
              date TEXT
            )
    ''');
    } catch (e) {
      print('Error initializing the database: $e');
    }
  }

  // create a new income record
  Future<int?> createIncome(Income income) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.insert('income', income.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // read income records
  Future<List<Income>> readAllIncomes() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query('income');
    return List.generate(maps!.length, (i) {
      return Income.fromMap(maps[i]);
    });
  }

  // update income record by id
  Future<int?> updateIncome(Income income) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.update(
      'income',
      income.toMap(),
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  // delete income record by id
  Future<int?> deleteIncome(int id) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.delete(
      'income',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}