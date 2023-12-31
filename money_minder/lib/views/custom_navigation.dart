/// Containing the implementation of the 'CustomNavigation' widget.
/// The widget displays the custom appbar and custom bottom navigation bar which
/// will be  used by all other pages(screens).

import 'package:flutter/material.dart';
import 'package:money_minder/views/transactions_page.dart';
import 'reminders_page.dart';
import 'investment_insight.dart';
import 'add_transaction.dart';
import 'setting_page.dart';
import 'financial_insights.dart';
import 'budget_goals_page.dart';

/// Class to implement the Custom App Bar for header of app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(

        // routes to different pages
        // from the popup menu that appears when clicking on the hamburger icon on the top left of the app.
        builder: (context) => PopupMenuButton(
          icon: Icon(Icons.menu, color: Colors.white),
          color: Colors.black,
          itemBuilder: (BuildContext context) {
            return [
              _buildPopupMenuItem(Icons.home,'Home', TransactionsPage(), context),
              _buildPopupMenuItem(Icons.insights, 'Financial Insights', FinancialInsightsPage(), context),
              _buildPopupMenuItem(Icons.stacked_line_chart_rounded,'Investment Insights', InsightsPage(), context),
              _buildPopupMenuItem(Icons.receipt_sharp,'Budget Goals', GoalsPage(), context),
              _buildPopupMenuItem(Icons.notifications, 'Reminders', RemindersPage(), context),
              _buildPopupMenuItem(Icons.settings, 'Settings', SettingsPage(), context),
            ];
          },
        ),
      ),

      //design for center of the top nav bar
      title: Center(
        child: Container(
          height: 40,
          width: 80,
          child: Image.asset( //adds logo
            'assets/logo.png',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.person, color: Colors.white),
          onPressed: () {
            // Navigate to the Settings page when the icon is clicked
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.white,
          height: 1.0,
        ),
      ),
    );
  }

  ///Method to design and implement the hamburger popup menu
  PopupMenuItem _buildPopupMenuItem(IconData icon, String text, Widget destination, BuildContext context) {
    return PopupMenuItem(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
              if (destination != null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => destination,
                ));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: Colors.white),
                      SizedBox(width: 8.0), // Spacing between icon and text
                      Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

/// Class for custom bottom navigation bar widget for footer of the app
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //builds the bottom bar with icons and labels
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
          icon: Icon(Icons.add),
          label: 'Add',
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
      currentIndex: currentIndex,
      selectedItemColor: Color(0xFF5E17EB),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        onTap(index); // Call the onTap function when creating

        switch (index) { // logic to navigate to specific pages based on index
          case 0:
          // Navigate to the Home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TransactionsPage()),
            );
            break;
          case 1:
          // Navigate to the Insights page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FinancialInsightsPage()),
            );
            break;
          case 2:
          // Navigate to the Add page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddTransactionForm(onExpenseAdded: (Expense ) {  },)),
            );
            break;
          case 3:
          // Navigate to the Reminders page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RemindersPage()),
            );
            break;
          case 4:
          // Navigate to the Settings page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
            break;
        }
      },
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    );
  }
}
