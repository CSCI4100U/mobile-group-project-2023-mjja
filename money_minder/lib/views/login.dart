import 'package:flutter/material.dart';
import '../models/login_model.dart';
import 'sign_up.dart';
import 'home_page.dart';
import 'forgot_password.dart';

class WelcomeBackPage extends StatelessWidget {
  final Color backgroundColor = Colors.black;
  final Color purpleColor = Color(0xFF5E17EB);
  final Color textColor = Colors.white;

  // Initialize LoginDatabase instance
  final LoginDatabase loginDatabase = LoginDatabase();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                              builder: (context) => HomePage(),
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
