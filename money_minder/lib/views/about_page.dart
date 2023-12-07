/// File: about_page.dart
/// Description: A Flutter Dart file containing the implementation of the 'AboutPage' widget.
/// The widget displays information about the MoneyMinder application, including version details,
/// package information, and developer information.


import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'custom_navigation.dart';


class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

/// The state class associated with the AboutPage widget.
/// It contains the implementation for getting and displaying package information.
class _AboutPageState extends State<AboutPage> {
  final Color backgroundColor = Colors.black;
  final Color textColor = Colors.white;
  final Color purpleColor = Color(0xFF5E17EB);

  // Initialize variables for package info
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  ///Asynchronous function to get package information from the platform
  /// using the 'package_info' package.
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      appName = info.appName;
      packageName = info.packageName;
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('About'),
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              appName,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: purpleColor),
            ),
            SizedBox(height: 10),
            Text(
              'Version: $version ($buildNumber)',
              style: TextStyle(fontSize: 18.0, color: textColor),
            ),
            SizedBox(height: 20),
            Text(
              'Package Name: $packageName',
              style: TextStyle(fontSize: 18.0, color: textColor),
            ),
            SizedBox(height: 20),
            Text(
              'MoneyMinder is a finance app that is designed to make daily tasks easier and efficient. '
                  'The purpose of this application is to develop a robust and user-friendly mobile application '
                  'to track expenses, analyze spending patterns, and manage budgets and stocks. '
                  'The developers of this application aim to provide users with a comprehensive tool to organize'
                  'and manage their daily expenses. ',

              style: TextStyle(fontSize: 16.0, color: textColor),
            ),
      SizedBox(height: 20),
      Text(
          'Developed by: Jessica Patel, Mansi Patel, Aanisha Newaz, Jahanvi Mathukia, Ethan Randle-Bragg',
        style: TextStyle(fontSize: 16.0, color: textColor),
      ),
            SizedBox(height: 20),
            Text(
              'Thank you for choosing MoneyMinder. We hope it makes your life a little easier and a lot more organized.',
              style: TextStyle(fontSize: 16.0, color: textColor),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
        },
      ),
    );
  }
}
