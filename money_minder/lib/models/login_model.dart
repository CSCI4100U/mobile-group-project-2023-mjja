/// LoginDatabase: This class contains all the initialize and CRUD method related to Login class

import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/localDB/login.dart';
import '../data/localDB/db_utils.dart';

class LoginDatabase {
  final dbUtils = DBUtils();

  //firebase call
  final CollectionReference loginCollection =
  FirebaseFirestore.instance.collection('logins');

  // initialize database and create table if does not exists
  Future<void> initializeDatabase() async {
    try {
      final db = await dbUtils.database;
      await db.execute('''
      CREATE TABLE IF NOT EXISTS login(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
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

    try {
      // Insert the login record without specifying the id
      int? id = await db.insert('login', login.toMap());

      // Update the Login object with the generated id
      login.id = id;

      // Return the id
      return id;
    } catch (e) {
      print('Error creating login: $e');
      return null;
    }
  }

  // read login records
  Future<List<Login>> readLogin() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query('login');
    return List.generate(maps.length, (i) {
      return Login.fromMap(maps[i]);
    });
  }

  // check if log in already existes in firebase
  Future<bool> checkLoginCredentialsFirebase(
      String emailAddress, String password) async {
    try {
      QuerySnapshot querySnapshot = await loginCollection
          .where('emailAddress', isEqualTo: emailAddress)
          .limit(1) // Limit to 1 result since you expect only one match
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Check password manually
        final storedPassword = querySnapshot.docs.first['password'];
        if (storedPassword == password) {
          print('Login successful for $emailAddress');
          return true;
        }
      }
      print('Login unsuccessful for $emailAddress');
      return false;
    } catch (e) {
      print('Error checking login credentials, check Firebase DB: $e');
      return false;
    }
  }
}
