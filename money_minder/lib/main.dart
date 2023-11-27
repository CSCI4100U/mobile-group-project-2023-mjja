// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'data/sqlite.dart';
import 'data/firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Money Minder'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Run SQLite test
              testSQLite();

              // Start the periodic sync task
              startSyncTask();
            },
            child: const Text('Test SQLite and Sync to Firebase'),
          ),
        ),
      ),
    );
  }
}
