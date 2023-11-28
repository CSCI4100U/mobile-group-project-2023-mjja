import 'package:flutter/material.dart';
import 'package:money_minder/views/custom_navigation.dart';

final Color purpleColor = Color(0xFF5E17EB);

class BudgetsPage extends StatefulWidget {
  @override
  _BudgetsPageState createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  List<Budget> budgets = [
    Budget(category: "Groceries", totalAmount: 500.0, amountSpent: 300.0),
    // Add more budgets as needed
  ];

  void _addBudget(String category, double amount) {
    setState(() {
      budgets.add(Budget(category: category, totalAmount: amount, amountSpent: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final budget = budgets[index];
          final progress = budget.amountSpent / budget.totalAmount;
          return Card(
            child: ListTile(
              title: Text(budget.category),
              subtitle: LinearProgressIndicator(
                value: progress,
                backgroundColor: purpleColor.withOpacity(0.3), // Lighter shade for the track
                valueColor: AlwaysStoppedAnimation<Color>(purpleColor), // Purple color for the progress
              ),
              trailing: Text('\$${budget.amountSpent}/\$${budget.totalAmount}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetDialog(context),
        child: Icon(Icons.add),
        backgroundColor: purpleColor, // Set the background color to purpleColor
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation bar item taps
        },
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    final _categoryController = TextEditingController();
    final _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Budget Category'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(primary: purpleColor), // Change text color to purple
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                final category = _categoryController.text;
                final amount = double.tryParse(_amountController.text) ?? 0;
                _addBudget(category, amount);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(primary: purpleColor), // Change text color to purple
            ),
          ],
        );
      },
    );
  }
}

class Budget {
  String category;
  double totalAmount;
  double amountSpent;

  Budget({required this.category, required this.totalAmount, required this.amountSpent});
}
