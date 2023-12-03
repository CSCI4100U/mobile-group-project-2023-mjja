import 'package:flutter/material.dart';
import 'package:money_minder/views/expenses.dart';
import 'reminders_page.dart';
import 'under_construction.dart';
import 'insights_page.dart';
import 'goals_page.dart';
import 'package:money_minder/views/home_page.dart';
import 'package:intl/intl.dart';
import 'profile_page.dart';
import 'add_expense.dart';
import 'budgets.dart';
import 'setting_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) => PopupMenuButton(
          icon: Icon(Icons.menu, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return [
              // PopupMenuItem(
              //   child: Text('Home'),
              //   onTap: () {
              //     // Handle the menu item tap
              //     Navigator.pop(context); // Close the menu
              //     // Navigate to the Home page or perform any other action
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => ExpensesPage(),
              //     ));
              //   },
              // ),
              PopupMenuItem(
                child: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ExpensesPage(),
                  ));
                  // Handle the Expenses page tap
                },
              ),
              PopupMenuItem(
                child: Text('Financial Insights'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle the Financial Insights page tap
                },
              ),
              PopupMenuItem(
                child: Text('Budgets'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle the Budgets page tap
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BudgetsPage(),
                  ));
                },
              ),
              PopupMenuItem(
                child: Text('Reminders'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RemindersPage(),
                  ));
                  // Handle the Financial Insights page tap
                },
              ),
              PopupMenuItem(
                child: Text('Goals'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle the Financial Insights page tap
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GoalsPage(),
                  ));
                },
              ),
              PopupMenuItem(
                child: Text('Investment Insights'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InsightsPage(),
                  ));
                  // Handle the Financial Insights page tap
                },
              ),
              PopupMenuItem(
                child: Text('Net Worth'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle the Financial Insights page tap
                },
              ),
              PopupMenuItem(
                child: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ));
                  // Handle the Financial Insights page tap
                },
              ),
              // Add more menu items as needed
            ];
          },
        ),
      ),
      title: Center(
        child: Container(
          height: 40,
          width: 80,
          child: Image.asset(
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
            // Navigate to the ProfilePage when the icon is selected
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
        // Call the onTap function provided when creating the widget
        onTap(index);

        // Add logic to navigate to specific pages based on the selected index
        switch (index) {
          case 0:
            // Navigate to the Home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ExpensesPage()),
            );
            break;
          case 1:
            // Navigate to the Insights page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InsightsPage()),
            );
            break;
          case 2:
            // Navigate to the Add page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddExpenseForm(onExpenseAdded: (Expense ) {  },)),
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
