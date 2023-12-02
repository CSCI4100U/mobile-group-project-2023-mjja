// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:money_minder/views/home_page.dart';

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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// firebase dependencies
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'views/notifications_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'views/reminders_page.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text('Money Minder'),
      //   ),
      // ignore: prefer_const_literals_to_create_immutables

      // localizationsDelegates: [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   const Locale('en', ''), // English, no country code
      //   const Locale('es', ''), // Spanish, no country code
      // ],
      home: HomePage(),

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
