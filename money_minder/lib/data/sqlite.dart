import 'package:flutter/material.dart';

// models and views import
import '../data/localDB/accountInfo.dart';
import '../models/accountInfo_model.dart';
import '../models/signup_model.dart';
import '../models/login_model.dart';
import '../models/expense_model.dart';
import '../data/localDB/signup.dart';
import '../data/localDB/login.dart';
import '../data/localDB/expenses.dart';
import '../views/LogIn.dart';

// firebase dependencies
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//libraries for firebase update
import 'dart:async';
//import 'package:timer/timer.dart';


//********************************************************************************
//*******************************   SQLite test code ******************************

Future<void> testSQLite() async {
    // await testSignup();
    await testExpense();
    await testLogin();
    // await testAccountInfo();

  }

  void printSignupRecords(List<Signup> signups) {
    print('************ Signup Records **********************');
    signups.forEach((signup) {
      print('Id: ${signup.id} Username: ${signup.username}, Fullname: ${signup.fullName}, '
          'Email: ${signup.emailAddress}, Password: ${signup.password}');
    });
  }

  void printLoginRecords(List<Login> logins) {
    print('************ Login Records **********************');
    logins.forEach((login) {
      print(' Id: ${login.id}  Email: ${login.emailAddress}, Password: ${login
          .password}');
    });
  }

  void printAccountInfoRecords(List<AccountInfo> accountInfos) {
    print('************ AccountInfo Records **********************');
    accountInfos.forEach((accountInfo) {
      print(accountInfo.toMap());
    });
  }


  Future<void> testExpense() async {
    final expense1 = Expense(
      id: 1,
      name: 'Groceries',
      category: 'Food',
      amount: 50.0,
      date:null,
    );
    final expense2 = Expense(
      id: 2,
      name: 'Subway',
      category: 'Food',
      amount: 100.0,
      date: null,
    );

    final db = ExpenseDatabase();
    await db.createExpense(expense1);
    await db.createExpense(expense2);

    // Read all expenses
    List<Expense> expenses = await db.readAllExpenses();
    print(
        '********************* Expenses records ****************************');
    for (final exp in expenses) {
      print('id: ${exp.id}, Expense: ${exp.name}, Amount: ${exp.amount}, date: ${exp.date}');
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
    print(
        '********************* Login records ****************************');
    for (final log in logins) {
      print('Email: ${log.emailAddress},Password: ${log.password}');
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
    }

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




