import 'package:flutter/material.dart';
import 'login.dart';
import 'sign_up.dart';


class SignInScreen extends StatelessWidget {
  final Color purpleColor = Color(0xFF5E17EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center( // Center the items
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png', //logo path
                  width: 180.0,
                  height: 200.0,
                ),
                Text(
                  'MONEY MINDER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage your daily finances in a central location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: purpleColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Padding inside button
                  ),
                  onPressed: () {
                    // Navigate to the LogIn when the button is pressed
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WelcomeBackPage(),
                    ));
                  },
                  child: Text(
                    'Sign In with Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: purpleColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Padding insidebutton
                  ),
                  onPressed: () {
                    // Navigate to the SignUp when the button is pressed
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignUpPage(),
                    ));
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30.0), // Space after buttons
                Text(
                  'By continuing you agree to terms and conditions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
