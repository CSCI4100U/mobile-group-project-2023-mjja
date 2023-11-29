// ## Acknowledgments
// The code in this project was developed with the assistance of ChatGPT, an AI language model created by OpenAI.

import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'custom_navigation.dart';

final Color backgroundColor = Colors.black;
final Color purpleColor =
Color(0xFF5E17EB); // Replace with your exact color code
final Color textColor = Colors.white;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin{
  final Color backgroundColor = Colors.black;
  final Color purpleColor =
  Color(0xFF5E17EB); // Replace with your exact color code
  final Color textColor = Colors.white;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        color: Colors.black, // Adjust the color to match the screenshot
        child: Column(
          children: [
            SizedBox(height: 20), // Spacing
            CircleAvatar(
              radius: 40, // Adjust the size as needed
              backgroundColor: Colors.black, // Placeholder for profile image
              child: Icon(Icons.person, size: 70, color: Colors.white), // Default user icon
            ),
            SizedBox(height: 10), // Spacing
            Text(
              'JOHN DOE',
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              'johndoe123@gmail.com',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 20), // Spacing
            ElevatedButton(
              onPressed: () {
                // TODO: Implement Edit Profile navigation
              },
              child: Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                primary: purpleColor, // Background color of the button
                onPrimary: Colors.white, // Text color of the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // The border radius of the button, adjust for more roundness
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Optional: Adjust padding for larger size
                // You can also adjust the elevation and size here if needed
              ),
            ),
            SizedBox(height: 20), // Spacing
            Text(
              'Notifications',
              textAlign: TextAlign.left, // Correct property of Text widget
              style: TextStyle(
                color: Colors.grey[800], // Assumes grey[800] is the color you want
                fontSize: 16, // Set the font size
                // fontWeight, fontFamily, etc., can be added here if needed
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800], // Set the grey shade you prefer
                borderRadius: BorderRadius.circular(10.0), // Adjust the radius for desired curvature
              ),
              child: SwitchListTile(
                title: Text(
                  'Turn on Notifications',
                  style: TextStyle(color: Colors.white),
                ),
                value: false,
                onChanged: (bool value) {
                  // TODO: Implement notification toggle
                },
                activeColor: purpleColor, // Adjust the color to match the screenshot
              ),
            ),
            SizedBox(height: 20), // Spacing
            Text(
              'Invite Link',
              textAlign: TextAlign.left, // Correct property of Text widget
              style: TextStyle(
                color: Colors.grey[800], // Assumes grey[800] is the color you want
                fontSize: 16, // Set the font size
                // fontWeight, fontFamily, etc., can be added here if needed
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0), // Add padding inside the container for spacing
              decoration: BoxDecoration(
                color: Colors.grey[800], // Set the grey shade you prefer
                borderRadius: BorderRadius.circular(8.0), // Adjust the radius for desired curvature
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between the items
                children: <Widget>[
                  Text(
                    'Invite People',
                    style: TextStyle(
                      color: Colors.white, // Adjust the color as needed
                      fontSize: 16, // Set the font size
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement invite action
                    },
                    child: Text('Invite'),
                    style: ElevatedButton.styleFrom(
                      primary: purpleColor, // Background color of the button
                      onPrimary: Colors.white, // Text color of the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // The border radius of the button, adjust for more roundness
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Optional: Adjust padding for larger size
                      // You can also adjust the elevation and size here if needed
                    ),
                  ),
                ],
              ),
            ),

            Spacer(), // Pushes the logout to the bottom
            ListTile(
              title: Text('Log out', textAlign: TextAlign.center,                     style: TextStyle(
                color: Colors.white, // Adjust the color as needed
                fontSize: 16, fontWeight: FontWeight.bold // Set the font size
              ),
              ),
              onTap: () {
                // Implement forgot password functionality
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ));
              },
            ),
            Spacer(), // Extra space at the bottom if needed
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation bar item taps
        },
      ),

    );
  }
}
