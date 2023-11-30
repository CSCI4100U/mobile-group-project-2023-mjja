import 'package:flutter/material.dart';
import 'login.dart';
import 'sign_up.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends StatelessWidget {
  final Color purpleColor = Color(0xFF5E17EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          // Center the items
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
                  AppLocalizations.of(context)!.mm_slogan,
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20), // Padding inside button
                  ),
                  onPressed: () {
                    // Navigate to the LogIn when the button is pressed
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WelcomeBackPage(),
                    ));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.sign_in_with_email,
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20), // Padding insidebutton
                  ),
                  onPressed: () {
                    // Navigate to the SignUp when the button is pressed
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignUpPage(),
                    ));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.sign_up,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30.0), // Space after buttons
                Text(
                  AppLocalizations.of(context)!.agree_terms_and_cond,
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
