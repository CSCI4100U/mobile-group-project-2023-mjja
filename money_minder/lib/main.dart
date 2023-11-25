// import 'package:flutter/material.dart';
//
// // models and views import
// import 'data/localDB/accountInfo.dart';
// import 'models/accountInfo_model.dart';
// import 'models/signup_model.dart';
// import 'models/login_model.dart';
// import 'models/expense_model.dart';
// import 'data/localDB/signup.dart';
// import 'data/localDB/login.dart';
// import 'data/localDB/expenses.dart';
// import 'views/LogIn.dart';
//
// // firebase dependencies
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// //libraries for firebase update
// import 'dart:async';
// //import 'package:timer/timer.dart';
//
//
// //********************************************************************************
// //*******************************   SQLite test code ******************************
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Money Minder'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               await testAllFunctionality();
//             },
//             child: Text('Test All Functionality'),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> testAllFunctionality() async {
//     await testSignup();
//     await testLogin();
//     await testAccountInfo();
//     await testExpense();
//   }
//
//   Future<void> testSignup() async {
//     SignUpDatabase signUpDb = SignUpDatabase();
//     await signUpDb.initializeDatabase();
//
//     Signup signUpInfo = Signup(
//       emailAddress: 'signup85@example.com',
//       password: 'signup_password',
//       fullName: 'signupTF85',
//       username: 'signupTF85',
//     );
//
//     await signUpDb.transferToLogin(signUpInfo);
//     await signUpDb.checkSignUpInformation();
//     printSignupRecords(await signUpDb.readSignUp());
//
//     // Test deleting a signup record
//     List<Signup> signUpListBeforeDeletion = await signUpDb.readSignUp();
//     if (signUpListBeforeDeletion.isNotEmpty) {
//       int deletedId = signUpListBeforeDeletion.first.id!;
//       await signUpDb.deleteSignUp(deletedId);
//       print('Deleted signup record with ID: $deletedId');
//     } else {
//       print('No signup records to delete.');
//     }
//
//     // Reading the signup records after deletion
//     print('************ AFTER DELETION Signup ****************************');
//     printSignupRecords(await signUpDb.readSignUp());
//   }
//
//   Future<void> testLogin() async {
//     final login = Login(
//       emailAddress: 'test@example.com',
//       password: 'test1243',
//     );
//
//     final loginDb = LoginDatabase();
//     printLoginRecords(await loginDb.readLogin());
//
//     // Check login successful or fail
//     bool isLoginSuccessful = await loginDb.checkLoginCredentials(
//       'test@example.com',
//       'test1243',
//     );
//
//     if (isLoginSuccessful) {
//       print('Login successful!');
//     } else {
//       print('Invalid credentials. Login failed.');
//     }
//
//     bool isLoginFailed = await loginDb.checkLoginCredentials(
//       'sample@example.com',
//       'sample_password',
//     );
//     if (isLoginFailed) {
//       print('Login successful!');
//     } else {
//       print('Invalid credentials. Login failed.');
//     }
//
//     // Test deleting a login record
//     List<Login> loginListBeforeDeletion = await loginDb.readLogin();
//     if (loginListBeforeDeletion.isNotEmpty) {
//       int deletedId = loginListBeforeDeletion.first.id!;
//       await loginDb.deleteLogin(deletedId);
//       print('Deleted login record with ID: $deletedId');
//     } else {
//       print('No login records to delete.');
//     }
//
//     // Reading the login records after deletion
//     print(
//         '********************* AFTER DELETION Login ****************************');
//     printLoginRecords(await loginDb.readLogin());
//   }
//
//   Future<void> testAccountInfo() async {
//     AccountInfoDatabase accountInfoDb = AccountInfoDatabase();
//     await accountInfoDb.initializeDatabase();
//
//     AccountInfo accountInfo = AccountInfo(
//       emailAddress: 'john@example.com',
//       firstName: 'John',
//       lastName: 'Doe',
//       phoneNumber: '1234567890',
//     );
//     AccountInfo accountInfo2 = AccountInfo(
//       emailAddress: 'adam@example.com',
//       firstName: 'Adam',
//       lastName: 'Doe',
//       phoneNumber: '8528528899',
//     );
//
//     await accountInfoDb.createAccountInfo(accountInfo);
//     await accountInfoDb.createAccountInfo(accountInfo2);
//
//     print('****************** AccountInfo Table Data: **********************');
//     printAccountInfoRecords(await accountInfoDb.readAccountInfo());
//
//     // Update the accountInfo record
//     List<AccountInfo> accountInfoList = await accountInfoDb.readAccountInfo();
//     if (accountInfoList.isNotEmpty) {
//       AccountInfo existingAccountInfo = accountInfoList.first;
//       AccountInfo updatedAccountInfo = AccountInfo(
//         id: existingAccountInfo.id,
//         emailAddress: existingAccountInfo.emailAddress,
//         firstName: 'Updated John',
//         lastName: existingAccountInfo.lastName,
//         phoneNumber: existingAccountInfo.phoneNumber,
//       );
//       await accountInfoDb.updateAccountInfo(updatedAccountInfo);
//       print('Updated accountInfo record with ID: ${updatedAccountInfo.id}');
//     } else {
//       print('No accountInfo records to update.');
//     }
//
//     // Read accountInfo records after update
//     print('********************* AFTER Update AccountInfo ****************************');
//     printAccountInfoRecords(await accountInfoDb.readAccountInfo());
//
//     // Delete an accountInfo record
//     if (accountInfoList.isNotEmpty) {
//       int deletedId = accountInfoList.first.id!;
//       await accountInfoDb.deleteAccountInfo(deletedId);
//       print('Deleted accountInfo record with ID: $deletedId');
//     } else {
//       print('No accountInfo records to delete.');
//     }
//
//     // Read accountInfo records after delete
//     print('********************* AFTER Delete AccountInfo ****************************');
//     printAccountInfoRecords(await accountInfoDb.readAccountInfo());
//   }
//
//   Future<void> testExpense() async {
//     final expense1 = Expense(
//       name: 'Groceries',
//       category: 'Food',
//       amount: 50.0,
//       date: '2023/11/07',
//       description: 'Monthly grocery shopping',
//     );
//
//     final db = ExpenseDatabase();
//     await db.createExpense(expense1);
//
//     // Read all expenses
//     List<Expense> expenses = await db.readAllExpenses();
//     print('********************* Expenses records ****************************');
//     for (final exp in expenses) {
//       print('Expense: ${exp.name}, Amount: ${exp.amount}');
//     }
//   }
//
//   void printSignupRecords(List<Signup> signups) {
//     print('************ Signup Records **********************');
//     signups.forEach((signup) {
//       print('Id: ${signup.id} Username: ${signup.username}, Fullname: ${signup
//           .fullName}, '
//           'Email: ${signup.emailAddress}, Password: ${signup.password}');
//     });
//   }
//
//   void printLoginRecords(List<Login> logins) {
//     print('************ Login Records **********************');
//     logins.forEach((login) {
//       print(' Id: ${login.id}  Email: ${login.emailAddress}, Password: ${login
//           .password}');
//     });
//   }
//
//   void printAccountInfoRecords(List<AccountInfo> accountInfos) {
//     print('************ AccountInfo Records **********************');
//     accountInfos.forEach((accountInfo) {
//       print(accountInfo.toMap());
//     });
//   }
// }
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Money Minder'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               await testAllFunctionality();
//             },
//             child: const Text('Test All Functionality'),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> testAllFunctionality() async {
//     await testSignup();
//     await testLogin();
//     await testAccountInfo();
//     await testExpense();
//   }
//
//   Future<void> testSignup() async {
//     // Your existing code for signup
//
//     // Get the signup data
//     List<Signup> signups = await signUpDb.readSignUp();
//
//     // Transfer signup data to Firebase
//     await transferDataToFirebase(signups, 'signupCollection');
//   }
//
//   Future<void> testLogin() async {
//     // Your existing code for login
//
//     // Get the login data
//     List<Login> logins = await loginDb.readLogin();
//
//     // Transfer login data to Firebase
//     await transferDataToFirebase(logins, 'loginCollection');
//   }
//
//   Future<void> testAccountInfo() async {
//     // Your existing code for account info
//
//     // Get the account info data
//     List<AccountInfo> accountInfos = await accountInfoDb.readAccountInfo();
//
//     // Transfer account info data to Firebase
//     await transferDataToFirebase(accountInfos, 'accountInfoCollection');
//   }
//
//   Future<void> testExpense() async {
//     // Your existing code for expense
//
//     // Get the expense data
//     List<Expense> expenses = await db.readAllExpenses();
//
//     // Transfer expense data to Firebase
//     await transferDataToFirebase(expenses, 'expenseCollection');
//   }
//
//   Future<void> transferDataToFirebase(List<Map<String, dynamic>> data, String collectionName) async {
//     // Reference to the collection in Firebase
//     final CollectionReference collection = firestore.collection(collectionName);
//
//     // Iterate through each data item and add it to the Firebase collection
//     for (Map<String, dynamic> item in data) {
//       await collection.add(item);
//     }
//
//     print('Data added to the Firebase collection: $collectionName');
//   }
// }
//
// //
// // //////////  FIREBASE TEST DATA///////////////////////
// //
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
// //
// //   MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Money Minder'),
// //         ),
// //         body: Center(
// //           child: ElevatedButton(
// //             onPressed: () async {
// //               final expenseData1 = {
// //                 'name': 'Groceries',
// //                 'category': 'Food',
// //                 'amount': 50.0,
// //                 'date': '2023/11/07',
// //                 'description': 'Monthly grocery shopping',
// //               };
// //               final expenseData2 = {
// //                 'name': 'Electronics',
// //                 'category': 'Shopping',
// //                 'amount': 100.0,
// //                 'date': '2023/11/08',
// //                 'description': 'Purchased new gadgets',
// //               };
// //
// //               // Reference to the 'expenses' collection
// //               final CollectionReference expensesCollection = firestore.collection('expenses');
// //
// //               // Add an expense to the Firestore collection
// //               await expensesCollection.add(expenseData1);
// //               await expensesCollection.add(expenseData2);
// //
// //               print('Expenses added to the Firestore collection.');
// //
// //               // Query the Firestore collection to access expenses
// //               final QuerySnapshot expensesQuery = await expensesCollection.get();
// //
// //               for (final QueryDocumentSnapshot doc in expensesQuery.docs) {
// //                 final data = doc.data() as Map<String, dynamic>;
// //                 print('Expense: ${data['name']}, '
// //                     'Category: ${data['category']}, '
// //                     'Amount: ${data['amount']}, '
// //                     'Date: ${data['date']},'
// //                     'Description: ${data['description']}'
// //                 );
// //               }
// //             },
// //             child: const Text('Test Firebase Database'),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// // //////////////Firebase test code ends /////////////////
// // ////////////////////

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
              //startSyncTask();
            },
            child: const Text('Test SQLite and Sync to Firebase'),
          ),
        ),
      ),
    );
  }
}
