// lib/data/firebase_sync.dart

import 'dart:async';
import 'sqlite.dart'; // Import SQLite test code
import '../models/accountInfo_model.dart';
import '../models/signup_model.dart';
import '../models/login_model.dart';
import '../models/budget_model.dart';
import '../models/expense_model.dart';
import '../models/goal_model.dart';
import '../models/income_model.dart';
import '../data/localDB/accountInfo.dart';
import '../data/localDB/signup.dart';
import '../data/localDB/login.dart';
import '../data/localDB/expenses.dart';
import '../data/localDB/budget.dart';
import '../data/localDB/goals.dart';
import '../data/localDB/income.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Login>> fetchLoginsFromSQLite() async {
  final List<Login> logins = await LoginDatabase().readLogin();
  return logins.map((login) => Login.fromMap(login.toMap())).toList();
}

Future<List<Signup>> fetchSignupsFromSQLite() async {
  final List<Signup> signups = await SignUpDatabase().readSignUp();
  return signups.map((signup) => Signup.fromMap(signup.toMap())).toList();
}

Future<List<AccountInfo>> fetchAccountInfoFromSQLite() async {
  final List<AccountInfo> accountinfos = await AccountInfoDatabase().readAccountInfo();
  return accountinfos.map((accountinfo) => AccountInfo.fromMap(accountinfo.toMap())).toList();
}

Future<List<Expense>> fetchExpensesFromSQLite() async {
  final List<Expense> expenses = await ExpenseDatabase().readAllExpenses();
  return expenses.map((expense) => Expense.fromMap(expense.toMap())).toList();
}

Future<List<Income>> fetchIncomeFromSQLite() async {
  final List<Income> incomes = await IncomeDatabase().readAllIncomes();
  return incomes.map((income) => Income.fromMap(income.toMap())).toList();
}

Future<List<Budget>> fetchBudgetFromSQLite() async {
  final List<Budget> budgets = await BudgetDatabase().readAllBudgets();
  return budgets.map((budget) => Budget.fromMap(budget.toMap())).toList();
}

// Read data from SQLite and push it to Firebase Specific method for Signup
Future<void> syncSignupDataToFirebase(Signup signup) async {
  try {
    print('Syncing signup data from SQLite to Firebase...');

    // Reference to the 'signups' collection
    final CollectionReference signupsCollection = FirebaseFirestore.instance.collection('signups');

    // Push the new signup data to Firebase
    DocumentReference signupDocumentReference = await signupsCollection.add(signup.toMap());

    // Log the signup data after pushing to Firebase
    print('Signup data after pushing to Firebase: ${signup.toMap()}');

    // Create a corresponding login entry in SQLite
    final LoginDatabase loginDatabase = LoginDatabase();
    Login login = Login(emailAddress: signup.emailAddress, password: signup.password);

    // Add login to SQLite database
    await loginDatabase.createLogin(login);

    // Reference to the 'logins' collection
    final CollectionReference loginsCollection = FirebaseFirestore.instance.collection('logins');

    // Push the new login data to Firebase
    DocumentReference loginDocumentReference = await loginsCollection.add(login.toMap());

    print('Signup data synced to Firebase.');
  } catch (e) {
    print('Error syncing signup data to Firebase: $e');
  }
}


// Read data from SQLite and push it to Firebase
Future<void> syncDataToFirebase() async {

  final List<Login> logins = await fetchLoginsFromSQLite();
  final List<Signup> signups = await fetchSignupsFromSQLite();
  final List<AccountInfo> accountinfos = await fetchAccountInfoFromSQLite();
  final List<Expense> expenses = await fetchExpensesFromSQLite();
  final List<Income> incomes = await fetchIncomeFromSQLite();
  final List<Budget> budgets = await fetchBudgetFromSQLite();

  // Reference to the 'logins' collection
  final CollectionReference loginsCollection = FirebaseFirestore.instance.collection('logins');

  // Reference to the 'signups' collection
  final CollectionReference signupsCollection = FirebaseFirestore.instance.collection('signups');

  // Reference to the 'accountinfos' collection
  final CollectionReference accountinfosCollection = FirebaseFirestore.instance.collection('accountinfos');

  // Reference to the 'expenses' collection
  final CollectionReference expensesCollection = FirebaseFirestore.instance.collection('expenses');

  // Reference to the 'incomes' collection
  final CollectionReference incomesCollection = FirebaseFirestore.instance.collection('incomes');

  // Reference to the 'budgets' collection
  final CollectionReference budgetsCollection = FirebaseFirestore.instance.collection('budgets');

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

  // Add accountinfos to the batch\
  for(final accountinfo in accountinfos) {
    batch.set(accountinfosCollection.doc(accountinfo.id.toString()), accountinfo.toMap(), SetOptions(merge: true));
  }

  // Add expenses to the batch
  for (final expense in expenses) {
    batch.set(expensesCollection.doc(expense.id.toString()), expense.toMap(), SetOptions(merge: true));
  }

  // Add incomes to the batch
  for (final income in incomes) {
    batch.set(incomesCollection.doc(income.id.toString()), income.toMap(), SetOptions(merge: true));
  }

  // Add budgets to the batch
  for (final budget in budgets) {
    batch.set(budgetsCollection.doc(budget.id.toString()), budget.toMap(), SetOptions(merge: true));
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
