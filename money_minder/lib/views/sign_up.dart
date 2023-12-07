/// New users can create their account by entering:
///   - Email, Full name, Username, and Password (all required fields)
/// On clicking 'Create Account' button:
///   - All the data will be stored in SQLite and Firebase
///   - The emailAddress and password will be stored into 'Login' table allowing user to login next time without creating new account.
///   - The user will be routed to Login page where they can login with the email and password entered while creating account.

import 'package:flutter/material.dart';
import 'package:money_minder/views/login_page.dart';
import '../models/signup_model.dart';
import '../data/localDB/signup.dart';
import '../data/firebase.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

///Displays fields to enter user info
class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color backgroundColor = Colors.black;
  final Color textColor = Colors.white;
  final Color buttonColor = Color(0xFF5E17EB);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Email regex pattern for validation
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
  );

  // Password regex pattern for validation
  // (at least 8 characters, one uppercase, one lowercase, and one digit)
  final RegExp passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
  );

  /// Saves all signup data to SQLite and Firebase
  void _saveSignupDataToDatabase(BuildContext context) async {
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

        // For testing purpose - Log the signup data before adding to SQLite
        print('Signup data before adding to SQLite: ${signup.toMap()}');

        // Add signup data to SQLite database
        final SignUpDatabase signupDatabase = SignUpDatabase();
        await signupDatabase.createSignUp(signup);

        // Push signup data to Firebase
        await syncSignupDataToFirebase(signup);

        // Navigate to the login page
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(),
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
        child: SingleChildScrollView(
          //adjust the height of the form
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 0,
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
                        Text(
                          'Create Account',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 45.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "Let's create an account!",
                          style: TextStyle(color: textColor, fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30.0),

                        //Email address
                        TextFormField(
                          controller: emailController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Email *',
                            labelStyle: TextStyle(color: textColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),

                        //Full name
                        TextFormField(
                          controller: fullNameController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Full Name *',
                            labelStyle: TextStyle(color: textColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Full Name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),

                        // Username
                        TextFormField(
                          controller: usernameController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Username *',
                            labelStyle: TextStyle(color: textColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),

                        //Password
                        TextFormField(
                          controller: passwordController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Password *',
                            labelStyle: TextStyle(color: textColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: textColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
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

                        // Create account button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: buttonColor),
                          onPressed: () => _saveSignupDataToDatabase(context),
                          child: Text('Create Account',
                              style: TextStyle(color: textColor, fontSize: 18)),
                        ),
                        SizedBox(height: 16.0),

                        // Log in option
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                          },
                          child: Text(
                            'Have an account? Log In',
                            style: TextStyle(color: textColor, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
