/// SignUpDatabase: This class contains all the method related to intialize and perform CRUD operations in Signup class

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
          id INTEGER PRIMARY KEY AUTOINCREMENT,
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

    try {
      // Insert the signup record without specifying the id
      int? id = await db.insert('signup', signUp.toMap());

      // Update the Signup object with the generated id
      signUp.id = id;

      // Return the id
      return id;
    } catch (e) {
      print('Error creating signup: $e');
      return null;
    }
  }

  // read signup records
  Future<List<Signup>> readSignUp() async {
    await initializeDatabase();
    final db = await dbUtils.database;
    final List<Map<String, Object?>> maps = await db.query('signup');
    return List.generate(maps.length, (i) {
      return Signup.fromMap(maps[i]);
    });
  }

  // as user signs up for the app, make sure emailAddress and password is saved in login table
  Future<void> transferToLogin(Signup signUp) async {
    await initializeDatabase(); // Ensure the database is initialized

    // create the signup entry
    final signUpId = await createSignUp(signUp);

    // transfer to login if the signup was successful
    if (signUpId != null) {
      signUp.id = signUpId; // Update the id in the Signup object
      final loginDb = LoginDatabase();

      // Update the Login object with the generated id
      final login =
      Login(emailAddress: signUp.emailAddress, password: signUp.password);
      final loginId = await loginDb.createLogin(login);

      if (loginId != null) {
        login.id = loginId; // Update the id in the Login object
      }
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
