/// This files fetches data stored in SQLit for signup and login, and push it to firebase

import 'dart:async';
import '../models/signup_model.dart';
import '../models/login_model.dart';
import '../data/localDB/signup.dart';
import '../data/localDB/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Login>> fetchLoginsFromSQLite() async {
  final List<Login> logins = await LoginDatabase().readLogin();
  return logins.map((login) => Login.fromMap(login.toMap())).toList();
}

Future<List<Signup>> fetchSignupsFromSQLite() async {
  final List<Signup> signups = await SignUpDatabase().readSignUp();
  return signups.map((signup) => Signup.fromMap(signup.toMap())).toList();
}

// Read data from SQLite and push it to Firebase Specific method for Signup and login
Future<void> syncSignupDataToFirebase(Signup signup) async {
  try {
    print('Syncing signup data from SQLite to Firebase...');

    // Reference to the 'signups' collection
    final CollectionReference signupsCollection = FirebaseFirestore.instance.collection('signups');

    // Log the signup data after pushing to Firebase
    print('Signup data after pushing to Firebase: ${signup.toMap()}');

    // Create a corresponding login entry in SQLite
    final LoginDatabase loginDatabase = LoginDatabase();
    Login login = Login(emailAddress: signup.emailAddress, password: signup.password);

    // Add login to SQLite database
    await loginDatabase.createLogin(login);

    // Reference to the 'logins' collection
    final CollectionReference loginsCollection = FirebaseFirestore.instance.collection('logins');

    print('Signup data synced to Firebase.');
  } catch (e) {
    print('Error syncing signup data to Firebase: $e');
  }
}


// Read data from SQLite and push it to Firebase
Future<void> syncDataToFirebase() async {

  final List<Login> logins = await fetchLoginsFromSQLite();
  final List<Signup> signups = await fetchSignupsFromSQLite();

  // Reference to the 'logins' collection
  final CollectionReference loginsCollection = FirebaseFirestore.instance.collection('logins');

  // Reference to the 'signups' collection
  final CollectionReference signupsCollection = FirebaseFirestore.instance.collection('signups');

  // Create a batch for simultaneous write/update to Firebase
  WriteBatch batch = FirebaseFirestore.instance.batch();

  // Add logins to the batch
  for (final login in logins) {
    batch.set(loginsCollection.doc(login.id.toString()), login.toMap(), SetOptions(merge: true));
  }

  // Add signups to the batch
  for (final signup in signups) {
    batch.set(signupsCollection.doc(signup.id.toString()), signup.toMap(), SetOptions(merge: true));
  }

  await batch.commit();

  print('Data synced to Firebase.');
}

void startSyncTask() {
  // Schedule the task to run every 30 minutes
  Timer.periodic(Duration(minutes: 1), (timer) async {
    await syncDataToFirebase();
  });
}
