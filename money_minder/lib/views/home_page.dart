// ## Acknowledgments
// The code in this project was developed with the assistance of ChatGPT, an AI language model created by OpenAI.
import 'package:flutter/material.dart';
import 'RemindersPage.dart' as reminders;
import 'UnderConstruction.dart' as setup;
import 'InsightsPage.dart' as insights;
import 'add_expense.dart' as addExpense;
import 'MainPage.dart';
import 'custom_navigation.dart';
import 'package:intl/intl.dart';


final Color backgroundColor = Colors.black;
final Color purpleColor =
Color(0xFF5E17EB); // Replace with your exact color code
final Color textColor = Colors.white;

class Expense {
  int? id;
  String name;
  String? category;
  double? amount;
  String? date;
  String? description;

  Expense({
    this.id,
    required this.name,
    this.category,
    this.amount,
    this.date,
    this.description,
  });

  IconData getIcon() {
    switch (category) {
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Transport':
        return Icons.directions_bus;
      case 'Income':
        return Icons.attach_money;
      default:
        return Icons.money_off;
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedTransactionType = 'All'; // Default selection
  DateTimeRange? _selectedDateRange;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          _buildTotalBalanceCard(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildTransactionTypeButtons(),
                  _buildRecentTransactionsTitle(),
                  _buildRecentTransactionList(),
                  // Add more widgets here that you want to scroll
                ],
              ),
            ),
          ),
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

  Widget _buildTotalBalanceCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Total Balance', style: TextStyle(color: Colors.black)),
                  Text('\$13,250', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: purpleColor)),
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
        ),
      ),
    );
  }
  Widget _buildTransactionTypeButtons() {
    // Function to build transaction type buttons with left alignment and smaller size
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Left align the buttons
        children: <Widget>[
          _transactionTypeButton('All'),
          SizedBox(width: 4), // Reduced space between the buttons
          _transactionTypeButton('Income'),
          SizedBox(width: 4), // Reduced space between the buttons
          _transactionTypeButton('Expense'),
        ],
      ),
    );
  }

  Widget _transactionTypeButton(String type) {
    bool isSelected = _selectedTransactionType == type;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.white : Color(0xFF5E17EB), // Background color
        onPrimary: isSelected ? Color(0xFF5E17EB) : Colors.white, // Text color
      ),
      onPressed: () {
        setState(() {
          _selectedTransactionType = type;
        });
        // Implement the logic to filter the transactions
      },
      child: Text(
        type,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  Widget _buildRecentTransactionsTitle() {
    return Container(
      color: Colors.black, // Set the background color
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(Icons.date_range, color: Colors.white),
            onPressed: () async {
              // Show a date range picker and update the selected date range
              DateTimeRange? pickedRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2022),
                lastDate: DateTime(2150),
                initialDateRange: _selectedDateRange,
              );
              if (pickedRange != null && pickedRange != _selectedDateRange) {
                setState(() {
                  _selectedDateRange = pickedRange;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionList() {
    // Hardcoded sample data
    List<Expense> transactions = [
      Expense(name: "FreshCo", category: "Shopping", amount: 45.90, date: "2023-11-19", description: "Grocery Store"),
      Expense(name: "Metro", category: "Transport", amount: 2.75, date: "2023-11-19", description: "Bus Ticket"),
      Expense(name: "Freelance", category: "Income", amount: 100.00, date: "2023-11-18", description: "Freelance Payment"),
      Expense(name: "Amazon", category: "Income", amount: 250.00, date: "2023-11-17", description: "Work Payment")
      // Add more transactions as needed
    ];

    // Filter transactions based on the selected type
    if (_selectedTransactionType != 'All') {
      bool isIncome = _selectedTransactionType == 'Income';
      transactions = transactions.where((tx) =>
      (isIncome && tx.category == 'Income') ||
          (!isIncome && tx.category != 'Income')).toList();
    }

    // Filter transactions based on the selected date range
    if (_selectedDateRange != null) {
      transactions = transactions.where((tx) {
        DateTime txDate = DateTime.parse(tx.date!);
        return _selectedDateRange!.start.isBefore(txDate) && _selectedDateRange!.end.isAfter(txDate);
      }).toList();
    }

    // Group transactions by date
    Map<String, List<Expense>> groupedTransactions = {};
    for (var transaction in transactions) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction.date!));
      if (!groupedTransactions.containsKey(formattedDate)) {
        groupedTransactions[formattedDate] = [];
      }
      groupedTransactions[formattedDate]!.add(transaction);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: groupedTransactions.entries.length,
      itemBuilder: (context, index) {
        String date = groupedTransactions.entries.elementAt(index).key;
        List<Expense> dailyTransactions = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.parse(date)),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            ...dailyTransactions.map((transaction) => Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black, // Black border color
                    width: 1.0, // Width of the border
                  ),
                ),
              ),
              child: ListTile(
                tileColor: Colors.white,
                leading: CircleAvatar(
                  backgroundColor: Color(0xFFF5F5DC), // Beige color
                  child: Icon(transaction.getIcon(), color: Colors.black),
                ),
                title: Text(
                  transaction.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                subtitle: Text(
                  'Category: ${transaction.category}',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  '${transaction.category == 'Income' ? '+' : '-'}\$${transaction.amount?.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: transaction.category == 'Income' ? Colors.green : Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )).toList(),
          ],
        );
      },
    );
  }




}


