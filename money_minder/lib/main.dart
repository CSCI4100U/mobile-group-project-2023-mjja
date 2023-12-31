// ignore_for_file: prefer_const_literals_to_create_immutables

//Acknowledgments
//The code in this project was developed with the assistance of an AI tool (cited below)
//OpenAI. (2023). ChatGPT [Large language model]. https://chat.openai.com
// https://github.com/Coding-Orbit/awesome_notification/blob/main/android/app/src/main/AndroidManifest.xml
// https://docs.flutter.dev/
// https://firebase.google.com/docs/cli#setup_update_cli
// https://pub.dev/packages/fl_chart
// https://github.com/imaNNeo/fl_chart/blob/master/repo_files/documentations/pie_chart.md
// http://stackoverflow.com/
// https://flutter.dev/docs/reference/tutorials
//https://iexcloud.io/docs
// Used google translate for spanish translations 
// Used the above links to help build this whole application

import 'package:flutter/material.dart';

// models and views import
import 'views/landing_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: LandingPage(),
    );
  }
}
