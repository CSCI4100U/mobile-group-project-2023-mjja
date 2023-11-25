// lib/data/firebase_sync.dart

import 'dart:async';
import 'sqlite.dart'; // Import SQLite test code
import '../models/login_model.dart';
import '../models/expense_model.dart';
import '../data/localDB/login.dart';
import '../data/localDB/expenses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Login>> fetchLoginsFromSQLite() async {
  final List<Login> logins = await LoginDatabase().readLogin();
  return logins.map((login) => Login.fromMap(login.toMap())).toList();
}

Future<List<Expense>> fetchExpensesFromSQLite() async {
  final List<Expense> expenses = await ExpenseDatabase().readAllExpenses();
  return expenses.map((expense) => Expense.fromMap(expense.toMap())).toList();
}

Future<void> syncDataToFirebase() async {
  // Your Firebase-related code to sync data...
  // Read data from SQLite and push it to Firebase

  final List<Login> logins = await fetchLoginsFromSQLite();
  final List<Expense> expenses = await fetchExpensesFromSQLite();

  // Reference to the 'logins' collection
  final CollectionReference loginsCollection = FirebaseFirestore.instance.collection('logins');
  // Reference to the 'expenses' collection
  final CollectionReference expensesCollection = FirebaseFirestore.instance.collection('expenses');

  // Create a batch for simultaneous write
  WriteBatch batch = FirebaseFirestore.instance.batch();

  // Add logins to the batch
  for (final login in logins) {
    batch.set(loginsCollection.doc(login.id.toString()), login.toMap(), SetOptions(merge: true));
  }

  // Add expenses to the batch
  for (final expense in expenses) {
    batch.set(expensesCollection.doc(expense.id.toString()), expense.toMap(), SetOptions(merge: true));
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
