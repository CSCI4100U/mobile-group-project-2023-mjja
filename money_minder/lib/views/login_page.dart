/// login page that allows user to enter an email and password to enter into an app.
/// also gives option to Forgot password, takes to password reset page by entering email address
/// Gives option to Sign Up if don't have an account

import 'package:flutter/material.dart';
import 'package:money_minder/views/transactions_page.dart';
import '../models/login_model.dart';
import 'sign_up.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color backgroundColor = Colors.black;
  final Color purpleColor = Color(0xFF5E17EB);
  final Color textColor = Colors.white;

  // Initialize LoginDatabase instance for SQLite
  final LoginDatabase loginDatabase = LoginDatabase();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

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
                      AppLocalizations.of(context)!.welcome,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      AppLocalizations.of(context)!.enter_email_pass,
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
                        labelText: AppLocalizations.of(context)!.email_star,
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
                          return AppLocalizations.of(context)!.email_req;
                        }
                        if (!emailRegex.hasMatch(value)) {
                          return AppLocalizations.of(context)!.email_valid;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.pass_star,
                        labelStyle: TextStyle(color: textColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                        ),
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
                      style: TextStyle(color: textColor),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.pass_req;
                        }
                        if (!passwordRegex.hasMatch(value)) {
                          return AppLocalizations.of(context)!.pass_statement;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: purpleColor,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String email = getEmail();
                          String password = getPassword().trim();

                          bool isLoggedIn = await loginDatabase
                              .checkLoginCredentialsFirebase(email, password);

                          if (isLoggedIn) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TransactionsPage(),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: purpleColor,
                              content: Text(
                                AppLocalizations.of(context)!
                                    .invalid_email_or_pass,
                              ),
                            ));
                          }
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.login,
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
                        AppLocalizations.of(context)!.dont_have_acc,
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
