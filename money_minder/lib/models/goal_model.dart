/**
 * GoalsDatabase: This class contains all the method related to Goal class
 */

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/localDB/db_utils.dart';
import '../data/localDB/goals.dart';

class GoalDatabase {
  final dbUtils = DBUtils();

  // initialize database and create table if does not exists
  Future<void> initializeDatabase() async {
    try {
      final db = await dbUtils.database;
      await db.execute('''
      CREATE TABLE IF NOT EXISTS goal(
              id INTEGER PRIMARY KEY,
              name TEXT,
              amount REAL,
              endDate TEXT
            )
    ''');
    } catch (e) {
      print('Error initializing the database: $e');
    }
  }

  // create a new goal record
  Future<int?> createGoal(Goal goal) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.insert('goal', goal.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // read goal records
  Future<List<Goal>> readAllGoals() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query('goal');
    return List.generate(maps!.length, (i) {
      return Goal.fromMap(maps[i]);
    });
  }

  // update goal record by id
  Future<int?> updateGoal(Goal goal) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.update(
      'goal',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  // delete goal record by id
  Future<int?> deleteGoal(int id) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.delete(
      'goal',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}