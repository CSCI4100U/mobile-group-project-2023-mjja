import 'package:flutter/material.dart';
import 'RemindersPage.dart' as reminders;
import 'UnderConstruction.dart' as setup;
import 'InsightsPage.dart' as insights;
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
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
      insights.InsightsPage(
        tabController: _tabController),
      reminders.RemindersPage(
          tabController: _tabController), // Using the RemindersPage class
      setup.UnderConstructionPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = getWidgetOptions(); // Get the list of widgets

    return Scaffold(
      appBar: AppBar(
        title: Text('MoneyMinder'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // The UI elements from the uploaded design will be added here
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Total Balance',
                                style: TextStyle(color: Colors.black)),
                            Text('\$13,250',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.black),
                          onPressed: () {
                            // Implement the export & share functionality
                          },
                        ),
                      ],
                    ),
                    // Add more UI elements similar to the above for the complete design
                  ],
                ),
              ),
            ),
          ),
          // Continue building out the rest of the UI in a similar fashion
        ],
      ),
    );
  }
}
