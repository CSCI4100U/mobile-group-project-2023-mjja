import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatefulWidget {
  @override
  _PrivacySecurityPageState createState() => _PrivacySecurityPageState();
}

final Color backgroundColor = Colors.black;
final Color textColor = Colors.white;
final Color purpleColor = Color(0xFF5E17EB);

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool isFeatureEnabled = false; // Example switch state

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
                'management services, or communicate with us. T'
                'his may include:'
                'Personal identification information (name, email address, phone number).'
            'Financial data (income, expenses, bank account details, transaction history).'
          'Device information (IP address, operating system, browser type).', style: TextStyle(color: textColor)),
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
              // Navigate to Terms of Service Page
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
              // Navigate to Data Usage Policy Page
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
              'Detailed information about privacy and security can be found at '
                  'our webiste',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          // Add more widgets as needed for additional information
        ],
      ),
    );
  }
}