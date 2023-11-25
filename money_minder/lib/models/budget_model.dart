/**
 * BudgetDatabase: This class contains all the method realted to Budget class
 */

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/localDB/db_utils.dart';
import '../data/localDB/budget.dart';

class BudgetDatabase {
  final dbUtils = DBUtils();

  // initialize database and create table if does not exists
  Future<void> initializeDatabase() async {
    try {
      final db = await dbUtils.database;
      await db.execute('''
      CREATE TABLE IF NOT EXISTS budget(
              id INTEGER PRIMARY KEY,
              name TEXT,
              category TEXT,
              amount REAL,
              endDate TEXT
            )
    ''');
    } catch (e) {
      print('Error initializing the database: $e');
    }
  }

  // create a new budget record
  Future<int?> createBudget(Budget budget) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.insert('budget', budget.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // read budget records
  Future<List<Budget>> readAllBudgets() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query('budget');
    return List.generate(maps!.length, (i) {
      return Budget.fromMap(maps[i]);
    });
  }

  // update budget record by id
  Future<int?> updateBudget(Budget budget) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.update(
      'budget',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  // delete budget record by id
  Future<int?> deleteBudget(int id) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.delete(
      'budget',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}