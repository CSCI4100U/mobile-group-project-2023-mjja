import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'main_page.dart';


class WelcomeBackPage extends StatelessWidget {
  final Color backgroundColor = Colors.black;
  final Color purpleColor = Color(0xFF5E17EB);
  final Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView( // Makes  UI scrollable
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'assets/logo.png',
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 80.0), // SPace top of  column
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Enter your email and password to access your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: textColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                    ),
                    style: TextStyle(color: textColor),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: textColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                    ),
                    style: TextStyle(color: textColor),
                    obscureText: true,
                  ),
                  SizedBox(height: 24.0),
                  TextButton(
                    onPressed: () {
                      // Implement forgot password functionality
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: purpleColor,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      // Implement login functionality
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ));
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  SizedBox(height: 80.0), // space @ bottom of column
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ));
                    },
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: textColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
