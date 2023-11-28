import 'package:flutter/material.dart';

// models and views import
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
import '../views/LogIn.dart';

// firebase dependencies
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

//libraries for firebase update
import 'dart:async';
// import 'package:timer/timer.dart';

//********************************************************************************
//*******************************   SQLite test code ******************************

Future<void> testSQLite() async {
  await testSignup();
  await testExpense();
  await testLogin();
  await testAccountInfo();
  await testBudget();
  await testGoal();
  await testIncome();
}

void printSignupRecords(List<Signup> signups) {
  print('************ Signup Records **********************');
  signups.forEach((signup) {
    print(
        'Id: ${signup.id} Username: ${signup.username}, Fullname: ${signup.fullName}, '
        'Email: ${signup.emailAddress}, Password: ${signup.password}');
  });
}

void printLoginRecords(List<Login> logins) {
  print('************ Login Records **********************');
  logins.forEach((login) {
    print(
        ' Id: ${login.id}  Email: ${login.emailAddress}, Password: ${login.password}');
  });
}

void printAccountInfoRecords(List<AccountInfo> accountInfos) {
  print('************ AccountInfo Records **********************');
  accountInfos.forEach((accountInfo) {
    print(accountInfo.toMap());
  });
}

Future<void> testExpense() async {
  final db = ExpenseDatabase();

  // Create expense records
  final expense1 = Expense(
    id: 1,
    name: 'Groceries',
    category: 'Food',
    amount: 50.0,
    date: DateTime.now().add(Duration(days: 30)),
  );
  final expense2 = Expense(
    id: 2,
    name: 'Subway',
    category: 'Food',
    amount: 100.0,
    date: DateTime.now().add(Duration(days: 3)),
  );

  // Test createExpense method
  await db.createExpense(expense1);
  await db.createExpense(expense2);

  // Read all expenses
  List<Expense> expenses = await db.readAllExpenses();
  print('********************* Expenses records after creation ****************************');
  for (final exp in expenses) {
    print(
        'id: ${exp.id}, Expense: ${exp.name}, Amount: ${exp.amount}, date: ${exp.date}');
  }

  // Test updateExpense method
  if (expenses.isNotEmpty) {
    Expense expenseToUpdate = expenses.first;
    Expense updatedExpense = Expense(
      id: expenseToUpdate.id,
      name: 'Updated ${expenseToUpdate.name}',
      category: expenseToUpdate.category,
      amount: expenseToUpdate.amount! + 10.0,
      date: expenseToUpdate.date!.add(Duration(days: 5)),
    );
    await db.updateExpense(updatedExpense);
    print('Updated expense record with ID: ${updatedExpense.id}');
  } else {
    print('No expense records to update.');
  }

  // Read expenses after update
  expenses = await db.readAllExpenses();
  print('********************* Expenses records after update ****************************');
  for (final exp in expenses) {
    print(
        'id: ${exp.id}, Expense: ${exp.name}, Amount: ${exp.amount}, date: ${exp.date}');
  }

  // Test deleteExpense method
  if (expenses.isNotEmpty) {
    int expenseToDeleteId = expenses.first.id!;
    await db.deleteExpense(expenseToDeleteId);
    print('Deleted expense record with ID: $expenseToDeleteId');
  } else {
    print('No expense records to delete.');
  }

  // Read expenses after delete
  expenses = await db.readAllExpenses();
  print('********************* Expenses records after delete ****************************');
  for (final exp in expenses) {
    print(
        'id: ${exp.id}, Expense: ${exp.name}, Amount: ${exp.amount}, date: ${exp.date}');
  }
}


Future<void> testLogin() async {
  final login1 = Login(
    id: 1,
    emailAddress: 'test@example.com',
    password: 'test1243',
  );
  final login2 = Login(
    id: 2,
    emailAddress: 'test2@example.com',
    password: 'test21243',
  );

  // printLoginRecords(await loginDb.readLogin());
  final db = LoginDatabase();
  await db.createLogin(login1);
  await db.createLogin(login2);

  // Read all expenses
  List<Login> logins = await db.readLogin();
  print('********************* Login records ****************************');
  for (final log in logins) {
    print('Email: ${log.emailAddress},Password: ${log.password}');
  }
}
Future<void> testSignup() async {
  SignUpDatabase signUpDb = SignUpDatabase();
  await signUpDb.initializeDatabase();

  Signup signUpInfo = Signup(
    emailAddress: 'signup85@example.com',
    password: 'signup_password',
    fullName: 'signupTF85',
    username: 'signupTF85',
  );

  await signUpDb.transferToLogin(signUpInfo);
  await signUpDb.checkSignUpInformation();
  printSignupRecords(await signUpDb.readSignUp());

    // Test deleting a signup record
  List<Signup> signUpListBeforeDeletion = await signUpDb.readSignUp();
  if (signUpListBeforeDeletion.isNotEmpty) {
    int deletedId = signUpListBeforeDeletion.first.id!;
    await signUpDb.deleteSignUp(deletedId);
    print('Deleted signup record with ID: $deletedId');
  } else {
    print('No signup records to delete.');
  }

    // Reading the signup records after deletion
  print('************ AFTER DELETION Signup ****************************');
  printSignupRecords(await signUpDb.readSignUp());

  final loginDb = LoginDatabase();
  printLoginRecords(await loginDb.readLogin());

  // Check login successful or fail
  bool isLoginSuccessful = await loginDb.checkLoginCredentials(
    'test@example.com',
    'test1243',
  );

  if (isLoginSuccessful) {
    print('Login successful!');
  } else {
    print('Invalid credentials. Login failed.');
  }

  bool isLoginFailed = await loginDb.checkLoginCredentials(
    'sample@example.com',
    'sample_password',
  );
  if (isLoginFailed) {
    print('Login successful!');
  } else {
    print('Invalid credentials. Login failed.');
  }

  // Test deleting a login record
  List<Login> loginListBeforeDeletion = await loginDb.readLogin();
  if (loginListBeforeDeletion.isNotEmpty) {
    int deletedId = loginListBeforeDeletion.first.id!;
    await loginDb.deleteLogin(deletedId);
    print('Deleted login record with ID: $deletedId');
  } else {
    print('No login records to delete.');
  }

  // Reading the login records after deletion
  print(
      '********************* AFTER DELETION Login ****************************');
  printLoginRecords(await loginDb.readLogin());
}

Future<void> testAccountInfo() async {
  AccountInfoDatabase accountInfoDb = AccountInfoDatabase();
  await accountInfoDb.initializeDatabase();

  AccountInfo accountInfo = AccountInfo(
    emailAddress: 'signup85@example.com',
    password: 'signup_password',
    fullName: 'signupTF85',
    username: 'signupTF85',
  );
  AccountInfo accountInfo2 = AccountInfo(
    emailAddress: 'signuptest2@example.com',
    password: 'signup2_password',
    fullName: 'signup12TF85',
    username: 'signup12TF85',
  );

  await accountInfoDb.createAccountInfo(accountInfo);
  await accountInfoDb.createAccountInfo(accountInfo2);

  print('****************** AccountInfo Table Data: **********************');
  printAccountInfoRecords(await accountInfoDb.readAccountInfo());

  // Update the accountInfo record
  List<AccountInfo> accountInfoList = await accountInfoDb.readAccountInfo();
  if (accountInfoList.isNotEmpty) {
    AccountInfo existingAccountInfo = accountInfoList.first;
    AccountInfo updatedAccountInfo = AccountInfo(
      id: existingAccountInfo.id,
      emailAddress: existingAccountInfo.emailAddress,
      fullName: 'Updated John',
      username: existingAccountInfo.username,
      password: existingAccountInfo.password,
    );
    await accountInfoDb.updateAccountInfo(updatedAccountInfo);
    print('Updated accountInfo record with ID: ${updatedAccountInfo.id}');
  } else {
    print('No accountInfo records to update.');
  }

  // Read accountInfo records after update
  print(
      '********************* AFTER Update AccountInfo ****************************');
  printAccountInfoRecords(await accountInfoDb.readAccountInfo());

  // Delete an accountInfo record
  if (accountInfoList.isNotEmpty) {
    int deletedId = accountInfoList.first.id!;
    await accountInfoDb.deleteAccountInfo(deletedId);
    print('Deleted accountInfo record with ID: $deletedId');
  } else {
    print('No accountInfo records to delete.');
  }

  // Read accountInfo records after delete
  print(
      '********************* AFTER Delete AccountInfo ****************************');
  printAccountInfoRecords(await accountInfoDb.readAccountInfo());
}

Future<void> testBudget() async {
  final budget1 = Budget(
    id: 1,
    name: 'Monthly Groceries',
    category: 'Food',
    amount: 200.0,
    endDate: DateTime.now(),
  );
  final budget2 = Budget(
    id: 2,
    name: 'Entertainment',
    category: 'Entertainment',
    amount: 100.0,
    endDate: DateTime.now().add(Duration(days: 5)),
  );

  final db = BudgetDatabase();
  await db.createBudget(budget1);
  await db.createBudget(budget2);

  // Read all budgets
  List<Budget> budgets = await db.readAllBudgets();
  print(
      '********************* Budgets records ****************************');
  for (final budget in budgets) {
    print(
        'id: ${budget.id}, Budget: ${budget.name}, Amount: ${budget.amount}, End Date: ${budget.endDate}');
  }

  // Update a budget record
  if (budgets.isNotEmpty) {
    Budget existingBudget = budgets.first;
    Budget updatedBudget = Budget(
      id: existingBudget.id,
      name: 'Updated ${existingBudget.name}',
      category: existingBudget.category,
      amount: existingBudget.amount! + 50.0,
      endDate: existingBudget.endDate,
    );
    await db.updateBudget(updatedBudget);
    print('Updated budget record with ID: ${updatedBudget.id}');
  } else {
    print('No budget records to update.');
  }

  // Read budgets records after update
  print(
      '********************* AFTER Update Budgets ****************************');
  budgets = await db.readAllBudgets();
  for (final budget in budgets) {
    print(
        'id: ${budget.id}, Budget: ${budget.name}, Amount: ${budget.amount}, End Date: ${budget.endDate}');
  }

  // Delete a budget record
  if (budgets.isNotEmpty) {
    int deletedId = budgets.first.id!;
    await db.deleteBudget(deletedId);
    print('Deleted budget record with ID: $deletedId');
  } else {
    print('No budget records to delete.');
  }

  // Read budgets records after delete
  print(
      '********************* AFTER Delete Budgets ****************************');
  budgets = await db.readAllBudgets();
  for (final budget in budgets) {
    print(
        'id: ${budget.id}, Budget: ${budget.name}, Amount: ${budget.amount}, End Date: ${budget.endDate}');
  }
}

Future<void> testGoal() async {
  final goal1 = Goal(
    id: 1,
    name: 'Buy a new laptop',
    amount: 1000.0,
    endDate: DateTime.now(),
  );
  final goal2 = Goal(
    id: 2,
    name: 'Vacation in Europe',
    amount: 3000.0,
    endDate: DateTime.now().add(Duration(days: 2)),
  );

  final db = GoalDatabase();
  await db.createGoal(goal1);
  await db.createGoal(goal2);

  // Read all goals
  List<Goal> goals = await db.readAllGoals();
  print(
      '********************* Goals records ****************************');
  for (final goal in goals) {
    print('id: ${goal.id}, Goal: ${goal.name}, Amount: ${goal.amount}, End Date: ${goal.endDate}');
  }

  // Update a goal record
  if (goals.isNotEmpty) {
    Goal existingGoal = goals.first;
    Goal updatedGoal = Goal(
      id: existingGoal.id,
      name: 'Updated ${existingGoal.name}',
      amount: existingGoal.amount! + 500.0,
      endDate: DateTime.now().add(Duration(days: 10)),
    );
    await db.updateGoal(updatedGoal);
    print('Updated goal record with ID: ${updatedGoal.id}');
  } else {
    print('No goal records to update.');
  }

  // Read goals records after update
  print(
      '********************* AFTER Update Goals ****************************');
  goals = await db.readAllGoals();
  for (final goal in goals) {
    print('id: ${goal.id}, Goal: ${goal.name}, Amount: ${goal.amount}, End Date: ${goal.endDate}');
  }

  // Delete a goal record
  if (goals.isNotEmpty) {
    int deletedId = goals.first.id!;
    await db.deleteGoal(deletedId);
    print('Deleted goal record with ID: $deletedId');
  } else {
    print('No goal records to delete.');
  }

  // Read goals records after delete
  print(
      '********************* AFTER Delete Goals ****************************');
  goals = await db.readAllGoals();
  for (final goal in goals) {
    print('id: ${goal.id}, Goal: ${goal.name}, Amount: ${goal.amount}, End Date: ${goal.endDate}');
  }
}

Future<void> testIncome() async {
  final income1 = Income(
    id: 1,
    name: 'Salary',
    amount: 5000.0,
    date: DateTime.now(),
  );
  final income2 = Income(
    id: 2,
    name: 'Freelance Work',
    amount: 1000.0,
    date: DateTime.now().add(Duration(days: 2)),
  );

  final db = IncomeDatabase();
  await db.createIncome(income1);
  await db.createIncome(income2);

  // Read all incomes
  List<Income> incomes = await db.readAllIncomes();
  print(
      '********************* Incomes records ****************************');
  for (final income in incomes) {
    print(
        'id: ${income.id}, Income: ${income.name}, Amount: ${income.amount}, Date: ${income.date}');
  }

  // Update an income record
  if (incomes.isNotEmpty) {
    Income existingIncome = incomes.first;
    Income updatedIncome = Income(
      id: existingIncome.id,
      name: 'Updated ${existingIncome.name}',
      amount: existingIncome.amount! + 500.0,
      date: DateTime.now().add(Duration(days: 10)),
    );
    await db.updateIncome(updatedIncome);
    print('Updated income record with ID: ${updatedIncome.id}');
  } else {
    print('No income records to update.');
  }

  // Read incomes records after update
  print(
      '********************* AFTER Update Incomes ****************************');
  incomes = await db.readAllIncomes();
  for (final income in incomes) {
    print(
        'id: ${income.id}, Income: ${income.name}, Amount: ${income.amount}, Date: ${income.date}');
  }

  // Delete an income record
  if (incomes.isNotEmpty) {
    int deletedId = incomes.first.id!;
    await db.deleteIncome(deletedId);
    print('Deleted income record with ID: $deletedId');
  } else {
    print('No income records to delete.');
  }

  // Read incomes records after delete
  print(
      '********************* AFTER Delete Incomes ****************************');
  incomes = await db.readAllIncomes();
  for (final income in incomes) {
    print(
        'id: ${income.id}, Income: ${income.name}, Amount: ${income.amount}, Date: ${income.date}');
  }
}