// signup.dart

import 'package:flutter/material.dart';
import 'package:money_minder/views/login.dart';
import '../models/signup_model.dart';
import '../data/localDB/signup.dart';
import '../models/login_model.dart';
import '../data/localDB/login.dart';
import '../data/firebase.dart'; // Import your firebase_sync.dart file

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color backgroundColor = Colors.black;
  final Color textColor = Colors.white;
  final Color buttonColor = Color(0xFF5E17EB);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUp(BuildContext context) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // Form is valid, proceed with signup
        String email = emailController.text;
        String fullName = fullNameController.text;
        String username = usernameController.text;
        String password = passwordController.text;

        Signup signup = Signup(
          emailAddress: email,
          fullName: fullName,
          username: username,
          password: password,
        );
        signup.id = null;

        // Log the signup data before adding to SQLite
        print('Signup data before adding to SQLite: ${signup.toMap()}');

        // Add signup to SQLite database
        final SignUpDatabase signupDatabase = SignUpDatabase();
        await signupDatabase.createSignUp(signup);

        // Push signup data to Firebase
        await syncSignupDataToFirebase(signup);

        // Navigate to the home page
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WelcomeBackPage(),
        ));
      }
    } catch (e) {
      print('Error during signup: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'assets/logo.png',
                  width: 60.0,
                  height: 80.0,
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
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Email *',
                      labelStyle: TextStyle(color: textColor),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: fullNameController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Full Name *',
                      labelStyle: TextStyle(color: textColor),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: usernameController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Username *',
                      labelStyle: TextStyle(color: textColor),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: passwordController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Password *',
                      labelStyle: TextStyle(color: textColor),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: buttonColor),
                    onPressed: () => signUp(context),
                    child: Text('Sign Up', style: TextStyle(color: textColor)),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WelcomeBackPage(),
                      ));
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
      ),
    );
  }
}
