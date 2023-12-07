/// RemindersDatabase: This class contains all the initialize and CRUD methods related to Reminder class

import 'package:sqflite/sqflite.dart';
import '../data/localDB/db_utils.dart';
import '../data/localDB/reminders.dart';

class ReminderDatabase {
  final dbUtils = DBUtils();

  // initialize database and create table if does not exists
  Future<void> initializeDatabase() async {
    try {
      final db = await dbUtils.database;
      await db.execute('''
      CREATE TABLE IF NOT EXISTS reminder(
              id INTEGER PRIMARY KEY,
              title TEXT,
              description TEXT,
              endDate TEXT,
              isCompleted INTEGER, 
              isUrgent INTEGER
            )
    ''');
    } catch (e) {
      print('Error initializing the database: $e');
    }
  }

  // create a new goal record
  Future<int?> createReminder(Reminder reminder) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.insert('reminder', reminder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // read goal records
  Future<List<Reminder>> readAllReminders() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query('reminder');
    return List.generate(maps.length, (i) {
      return Reminder.fromMap(maps[i]);
    });
  }

  // update goal record by id
  Future<int?> updateGoal(Reminder reminder) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.update(
      'reminder',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  // delete reminder record by id
  Future<int?> deleteReminder(int id) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.delete(
      'reminder',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
