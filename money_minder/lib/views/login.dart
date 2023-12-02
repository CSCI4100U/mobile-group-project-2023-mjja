// login page that allows user to enter an email and password to enter into an app.
// also gives option to Forgot password, takes to password reset page by entering email address
// Gives option to Sign Up if don't have an account

import 'package:flutter/material.dart';
import 'package:money_minder/views/expenses.dart';
import '../models/login_model.dart';
import 'sign_up.dart';
import 'home_page.dart';
import 'forgot_password.dart';

class WelcomeBackPage extends StatelessWidget {
  final Color backgroundColor = Colors.black;
  final Color purpleColor = Color(0xFF5E17EB);
  final Color textColor = Colors.white;

  // Initialize LoginDatabase instance for SQLite
  final LoginDatabase loginDatabase = LoginDatabase();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Email regex pattern for validation
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
  );

  // Password regex pattern for validation
  // (at least 8 characters, one uppercase, one lowercase, and one digit)
  final RegExp passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
  );

  String getEmail() {
    return emailController.text;
  }

  String getPassword() {
    return passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                    SizedBox(height: 80.0),
                    Text(
                      'Welcome!',
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
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email *',
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password *',
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        if (!passwordRegex.hasMatch(value)) {
                          return 'Password must meet the following requirements:\n'
                              '• At least 8 characters long.\n'
                              '• At least one uppercase letter.\n'
                              '• At least one lowercase letter.\n'
                              '• At least one digit.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String email = getEmail();
                          String password = getPassword().trim();

                          bool isLoggedIn =
                          await loginDatabase.checkLoginCredentialsFirebase(email, password);

                          if (isLoggedIn) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ExpensesPage(),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Invalid email or password'),
                            ));
                          }
                        }
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    SizedBox(height: 80.0),
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
      ),
    );
  }
}
