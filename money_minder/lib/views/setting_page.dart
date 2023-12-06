import 'package:flutter/material.dart';
import 'package:money_minder/views/home_page.dart';
import 'package:money_minder/views/landing_page.dart';
import 'package:money_minder/views/under_construction.dart';
import 'custom_navigation.dart';
import 'privacy_security.dart';
import 'profile_page.dart';
import 'about_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final Color backgroundColor = Colors.black;
  final Color textColor = Colors.white;
  final Color purpleColor = Color(0xFF5E17EB);

  void _handleLogout() {

    Navigator.of(context).pushReplacementNamed('/login'); // Assuming '/login' is your login route
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Account', style: TextStyle(color: textColor,  fontWeight: FontWeight.bold,)),
            subtitle: Text('Manage your account', style: TextStyle(color: Colors.grey)),
            onTap: () {
              // Add logic to navigate to account settings
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ));

            },
            trailing: Icon(Icons.arrow_forward_ios, color: textColor),
          ),
          ListTile(
            title: Text('About', style: TextStyle(color: textColor,  fontWeight: FontWeight.bold,)),
            onTap: () {
              // Add logic to show about information
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AboutPage(),
              ));
            },
            trailing: Icon(Icons.info_outline, color: textColor),
          ),
          ListTile(
            title: Text('Privacy & Security', style: TextStyle(color: textColor,  fontWeight: FontWeight.bold,)),
            onTap: () {
              // Add logic to handle user logout
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PrivacySecurityPage(),
              ));
            },
            trailing: Icon(Icons.lock , color: textColor),
          ),
          ListTile(
            title: Text('Help & Support', style: TextStyle(color: textColor,  fontWeight: FontWeight.bold,)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UnderConstructionPage(),
              ));
            },
            trailing: Icon( Icons.help_center , color: textColor),
          ),
          ListTile(
            title: Text('Logout', style: TextStyle(color: textColor,  fontWeight: FontWeight.bold,)),
            onTap: () {
              // Add logic to handle user logout
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SignInScreen(),
              ));
            },
            trailing: Icon(Icons.exit_to_app, color: purpleColor),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          // Handle bottom navigation bar item taps
        },
      ),
    );
  }
}
