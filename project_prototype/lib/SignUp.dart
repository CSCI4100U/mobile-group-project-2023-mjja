import 'package:flutter/material.dart';
import '../LogIn.dart';

class SignUpPage extends StatelessWidget {
  final Color backgroundColor = Colors.black;
  final Color textColor = Colors.white;
  final Color buttonColor = Color(0xFF5E17EB); // Replace with your actual purple color code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body:  Stack( // Use Stack to overlay widgets
        children: [
          Positioned( // Position the image in the top left corner
            top: 15,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0), // Adjust padding as needed
              child: Image.asset(
                'assets/logo.png', // Replace with your image asset path
                width: 60.0, // Set the width of the image
                height: 80.0, // Set the height of the image
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Spacer(),
                Text(
                  'Create Account',
                  style: TextStyle(color: textColor, fontSize: 45.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  "Let's create an account",
                  style: TextStyle(color: textColor, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                // Email Input
                TextField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: textColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                  ),
                ),
                SizedBox(height: 16.0),
                // Full Name Input
                TextField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: textColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                  ),
                ),
                SizedBox(height: 16.0),
                // Username Input
                TextField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: textColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                  ),
                ),
                SizedBox(height: 16.0),
                // Password Input
                TextField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: textColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                // Confirm Password Input
                TextField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: textColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 24.0),
                // Sign Up Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: buttonColor),
                  onPressed: () {
                    // Handle sign up action
                  },
                  child: Text('Sign Up', style: TextStyle(color: textColor)),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // This assumes that you're pushing this page onto the stack
                  },
                  child: Text(
                    'Have an account? Log In',
                    style: TextStyle(color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}