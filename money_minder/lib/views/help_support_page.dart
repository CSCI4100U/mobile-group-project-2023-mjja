/// File: help_support_page.dart
/// Description: A Flutter Dart file containing the implementation of the 'HelpSupport' widget.
/// The widget displays information about how users can find help and support when using MoneyMinder
///
/// Includes:
/// FAQS, Contact, and Reporting

import 'package:flutter/material.dart';

// Default UI features (color theme)
final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

///Stateless class to display Help & Support information
class HelpSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          // Section for FAQs
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('Frequently Asked Questions',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            onTap: () {
              // no navigation
            },
          ),
          ExpansionTile(
            title: Text('How is my spending categorized in the app?',
                style: TextStyle(fontSize:12.5, color: textColor)),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('MoneyMinder categorizes your transactions based on the following categories:'
                    ' Food, Shopping, Travel, Bills, Education, Subscriptions, Home, Income, and Other',
                    style: TextStyle( color: textColor)),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How can I share my transaction history?',
                style: TextStyle(fontSize:12.5, color: textColor)),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Navigate to the home page and click on the share icon '
                    'located in the top right. Once you click this button you will be '
                    'given the option to save and share your transactiosn via email or drive.',
                    style: TextStyle( color: textColor)),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Are there any fees associated with using MoneyMinder??',
                style: TextStyle(fontSize:12.5, color: textColor)),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No there are no fees associated with MoneyMinder! We are an application '
                    'commited to delivering you the best results for free.',
                    style: TextStyle( color: textColor)),
              ),
            ],
          ),
          Divider(),

          // Section for Contact Support
          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text('Contact Support', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            subtitle: Text('Email: \n\n'
            'Jessica.patel@ontariotechu.ne '
                '\nAanisha.newaz@ontariotechu.net '
                '\nMansi.patel3@ontariotechu.net',style: TextStyle( color: textColor)),
            onTap: () {
              // no navigation
            },
          ),
          Divider(),

          // Section for Reporting Issues or Feedback
          ListTile(
            leading: Icon(Icons.bug_report),
            title: Text('Report an Issue', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            subtitle: Text('Email: \n\n'
                'Jessica.patel@ontariotechu.net '
                '\nAanisha.newaz@ontariotechu.net '
                '\nMansi.patel3@ontariotechu.net',style: TextStyle( color: textColor)),
            onTap: () {
              //no navigation
            },
          ),
        ],
      ),
    );
  }
}
