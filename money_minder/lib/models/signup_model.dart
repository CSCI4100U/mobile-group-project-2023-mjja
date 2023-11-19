/**
 * SignUpDatabase: This class contains all the method realted to Signup class
 */

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/localDB/login.dart';
import '../data/localDB/signup.dart';
import 'login_model.dart';
import '../data/localDB/db_utils.dart';

class SignUpDatabase {
  final dbUtils = DBUtils();

  // initialize database and create table if does not exists
  Future<void> initializeDatabase() async {
    try {
      final db = await dbUtils.database;
      await db.execute('''
        CREATE TABLE IF NOT EXISTS signup(
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

  // create a new signup record
  Future<int?> createSignUp(Signup signUp) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.insert('signup', signUp.toMap());
  }

  // read signup records
  Future<List<Signup>> readSignUp() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query('signup');
    return List.generate(maps!.length, (i) {
      return Signup.fromMap(maps[i]);
    });
  }

  // update signup record by id
  Future<int?> updateSignUp(Signup signUp) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.update(
      'signup',
      signUp.toMap(),
      where: 'id = ?',
      whereArgs: [signUp.id], // Assuming there is only one signup entry
    );
  }

  // delete signup record by id
  Future<int?> deleteSignUp(int id) async {
    await initializeDatabase();
    final db = await dbUtils.database;
    return await db.delete(
      'signup',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // as user signs up for the app, make sure related login gets created
  Future<void> transferToLogin(Signup signUp) async {
    await initializeDatabase(); // Ensure the database is initialized

    // create the signup entry
    final signUpId = await createSignUp(signUp);

    // transfer to login if the signup was successful
    if (signUpId != null) {
      final loginDb = LoginDatabase();
      final login =
          Login(emailAddress: signUp.emailAddress, password: signUp.password);
      await loginDb.createLogin(login);
    }
  }

  // make sure signup data is pushed to login
  Future<void> checkSignUpInformation() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>>? loginTableData = await db.query('login');

    print('SignUp Model: Login Table Data from:');
    loginTableData?.forEach((row) {
      print(row);
    });
  }
}