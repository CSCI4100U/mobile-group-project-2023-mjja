// ignore_for_file: prefer_const_literals_to_create_immutables

//Acknowledgments
//The code in this project was developed with the assistance of an AI tool (cited below)
//OpenAI. (2023). ChatGPT [Large language model]. https://chat.openai.com
// https://github.com/Coding-Orbit/awesome_notification/blob/main/android/app/src/main/AndroidManifest.xml
// Used the above link to help build awesome package notifications


import 'package:flutter/material.dart';

// models and views import
import 'views/login_page.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('es', ''), // Spanish, no country code
      ],
      home: SignInScreen(),

    );
  }
}