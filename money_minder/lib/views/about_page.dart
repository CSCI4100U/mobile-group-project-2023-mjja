/// The widget displays information about the MoneyMinder application, including version details,
/// package information, and developer information.

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'custom_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

/// Contains the implementation for getting and displaying package information.
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

  /// Function to get package information from the platform
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
        title: Text(
          AppLocalizations.of(context)!.about,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              appName,
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: textColor),
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
              AppLocalizations.of(context)!.statement,
              style: TextStyle(fontSize: 16.0, color: textColor),
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.developed_by,
              style: TextStyle(fontSize: 16.0, color: textColor),
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.thank_you,
              style: TextStyle(fontSize: 16.0, color: textColor),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {},
      ),
    );
  }
}
