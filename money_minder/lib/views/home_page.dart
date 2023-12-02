import 'package:flutter/material.dart';
import 'custom_navigation.dart';

final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB); // Replace with your exact color code
final Color textColor = Colors.white;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
        backgroundColor: backgroundColor,
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          BalanceCard(),
          SizedBox(height: 20),
          BudgetCard(),
        ],
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

class BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Total Balance',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              '\$13,250',
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            SizedBox(height: 20.0),
            ToggleButtons(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Income'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Expenses'),
                ),
              ],
              isSelected: [true, false],
              onPressed: (int index) {},
              borderRadius: BorderRadius.circular(12.0),
              fillColor: purpleColor,
              selectedColor: Colors.white,
            ),
            SizedBox(height: 20.0),
            Container(
              height: 200,
              // Placeholder for chart widget
              color: Colors.grey[300],
              child: Center(
                child: Text('Chart Placeholder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class BudgetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add your onTap functionality here
        print('Card tapped!');
      },
      child: Container(
        child: Card(
          color: purpleColor,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 80.0,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Your Budget Limit',
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Container(
                  height: 8.0,
                  width: double.infinity,
                  child: LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  '75% of Budget Used',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




