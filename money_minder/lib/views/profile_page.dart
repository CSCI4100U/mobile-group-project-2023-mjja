// ## Acknowledgments
// The code in this project was developed with the assistance of ChatGPT, an AI language model created by OpenAI.

import 'package:flutter/material.dart';
import 'MainPage.dart'; // Assuming you have a HomePage widget
import 'UnderConstruction.dart'; // Assuming you have a SettingsPage widget
import 'InsightsPage.dart'; // Assuming you have an InsightsPage widget
import 'RemindersPage.dart'; // Assuming you have a RemindersPage widget
import 'LandingPage.dart';

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

  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
  super.initState();
  _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
  _tabController.dispose();
  super.dispose();
  }

  List<Widget> getWidgetOptions() {
  return <Widget>[
  HomePage(), // The Home Page widget will go here
  // insights.InsightsPage(
  //     tabController: _tabController),
  UnderConstructionPage(), //temporary over insights page
  RemindersPage(
  tabController: _tabController), // Using the RemindersPage class
  UnderConstructionPage(),
  ];
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()));
        break;
      case 1:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UnderConstructionPage()));
        break;
      // case 2:
      //   Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (context) => reminder()));
      //   break;
      case 3:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UnderConstructionPage()));
        break;
    }
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Minder'),
        backgroundColor: Colors.black, // Adjust the color to match the screenshot
        leading: Image.asset(
          'assets/logo.png',
          width: 70.0,
          height: 70.0,
        ), // Menu icon
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.notifications_none, color: Colors.white), // Notification icon
          ),
        ],
      ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: purpleColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),

    );
  }
}
