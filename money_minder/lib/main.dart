import 'package:flutter/material.dart';

// models and views import
import 'data/localDB/accountInfo.dart';
import 'models/accountInfo_model.dart';
import 'models/signup_model.dart';
import 'models/login_model.dart';
import 'models/expense_model.dart';
import 'data/localDB/signup.dart';
import 'data/localDB/login.dart';
import 'data/localDB/expenses.dart';
import 'views/login.dart';
import 'views/landing_page.dart';
import 'views/custom_navigation.dart';

// firebase dependencies
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text('Money Minder'),
      //   ),
        home: SignInScreen(),

        // body: Center(
        //   child: ElevatedButton(
        //     onPressed: () async {
        //       await testAllFunctionality();
        //     },
        //     child: Text('Test All Functionality'),
        //   ),
        // ),
      //),

    );
  }
}
