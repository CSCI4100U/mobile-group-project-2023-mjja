/// File: privacy_security.dart
/// Description: A Flutter Dart file containing the implementation of the 'PrivacySecurity' widget.
/// The widget displays information about Privacy and Security about MoneyMinder
///
/// Includes:
/// Privacy Policy, Terms & Conditions, Data Usage Policy

import 'package:flutter/material.dart';



class PrivacySecurityPage extends StatefulWidget {
  @override
  _PrivacySecurityPageState createState() => _PrivacySecurityPageState();
}

// Default UI features (color theme)
final Color backgroundColor = Colors.black;
final Color textColor = Colors.white;
final Color purpleColor = Color(0xFF5E17EB);


///Class that displays the Privacy and Security information
class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Privacy & Security'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Divider(),
          ListTile(
            title: Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            subtitle: Text('We collect information that you provide directly to'
                ' us when you create an account, use our financial tracking and '
                'management services, or communicate with us. This may include:'
                'Personal identification information (name, email address, phone number).'
                'Financial data (income, expenses, bank account details, transaction history).'
                'Device information (IP address, operating system, browser type).',
                style: TextStyle(color: textColor)),
            onTap: () {
              //
            },
          ),
          ListTile(
            title: Text('Terms of Service', style: TextStyle( fontWeight: FontWeight.bold,color: textColor)),
            subtitle: Text('By using the Money Minder app, you agree to be bound'
                ' by these Terms of Service, which govern your use of our financial '
                'management services. Please read them carefully before accessing '
                'or using our app.', style: TextStyle(color: textColor)),
            onTap: () {
              // no navigation
            },
          ),
          ListTile(
            title: Text('Data Usage Policy', style: TextStyle(fontWeight: FontWeight.bold,
                color: textColor)),
            subtitle: Text('Money Minders Data Usage Policy outlines how we collect, '
                'use, and protect your financial data and personal information.'
                ' By using our app, you consent to these practices as described in '
                'our Privacy Policy', style: TextStyle(color: textColor)),
            onTap: () {
              // no navigation
            },
          ),
          Divider(),
          Text(
            'More Information',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Detailed information about privacy and security can be found at our webiste',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}