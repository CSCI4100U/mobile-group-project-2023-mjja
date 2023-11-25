/**
 * ExpenseDatabase: This class contains all the method realted to Expense class
 */

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/localDB/db_utils.dart';
import '../data/localDB/expenses.dart';
//import '../data/localDB/db_utils.dart';

class ExpenseDatabase {
  final dbUtils = DBUtils();

  // initialize database and create table if does not exists
  Future<void> initializeDatabase() async {
    try {
      final db = await dbUtils.database;
      await db.execute('''
      CREATE TABLE IF NOT EXISTS expenses(
              id INTEGER PRIMARY KEY,
              name TEXT,
              category TEXT,
              amount REAL,
              date TEXT
            )
    ''');
    } catch (e) {
      print('Error initializing the database: $e');
    }
  }

  // create a new expense record
  Future<int?> createExpense(Expense expense) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.insert('expenses', expense.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // read expense records
  Future<List<Expense>> readAllExpenses() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query('expenses');
    return List.generate(maps!.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  // update expense record by id
  Future<int?> updateExpense(Expense expense) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // delete expense record by id
  Future<int?> deleteExpense(int id) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
