//code for screen when click on Forgot password from Login page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sign_up.dart';

final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton( // arrow to take back to login page
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Oh, No! \n'
                  'I Forgot',
              style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: textColor),
            ),
            SizedBox(height: 10),
            Text(
              'Enter your email, and we\'ll send you a link to change a new password',
              style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
            ),
            SizedBox(height: 80),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Forgot Password',  style: TextStyle(color: textColor)),
              onPressed: () {
                // Handle forgot password logic
              },
              style: ElevatedButton.styleFrom(
                primary: purpleColor, // Background color
              ),
            ),
            TextButton(
              child: Text('Don\'t have an account? Sign Up'),
              onPressed: () {
                // Navigate to sign up page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignUpPage(),
                ));
              },
              style: TextButton.styleFrom(
                primary: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
