/// containing the implementation of the 'Settings' widget.
/// The widget displays the user settings of MoneyMinder

import 'package:flutter/material.dart';
import 'package:money_minder/views/landing_page.dart';
import 'custom_navigation.dart';
import 'privacy_security.dart';
import 'about_page.dart';
import 'help_support_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A Stateful Widget for settings page of the app.
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

///State class
/// Handles the UI and logic for user settings.
class _SettingsPageState extends State<SettingsPage> {
  final Color backgroundColor = Colors.black;
  final Color textColor = Colors.white;
  final Color purpleColor = Color(0xFF5E17EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.about,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AboutPage(), //Navigate to About page
              ));
            },
            trailing: Icon(Icons.info_outline, color: textColor),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.privacy_security,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PrivacySecurityPage(), //Navigate to Privacy and Security page
              ));
            },
            trailing: Icon(Icons.lock, color: textColor),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.help_support,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    HelpSupportPage(), //Navigate to Help & Support page
              ));
            },
            trailing: Icon(Icons.help_center, color: textColor),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.logout,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LandingPage(), //Logout of the app
              ));
            },
            trailing: Icon(Icons.exit_to_app, color: purpleColor),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {},
      ),
    );
  }
}
