import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/localDB/expenses.dart';
//import '../data/localDB/db_utils.dart';

class ExpenseDatabase {
  static Database? _database;

  Future<void> initializeDatabase() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'expenses.db'),
        onCreate: (db, version) {
          return db.execute('''
            CREATE TABLE expenses(
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

  Future<int?> createExpense(Expense expense) async {
    await initializeDatabase();
    return await _database?.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> readAllExpenses() async {
    await initializeDatabase();
    final List<Map<String, Object?>>? maps = await _database?.query('expenses');
    return List.generate(maps!.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<int?> updateExpense(Expense expense) async {
    await initializeDatabase();
    return await _database?.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int?> deleteExpense(int id) async {
    await initializeDatabase();
    return await _database?.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
