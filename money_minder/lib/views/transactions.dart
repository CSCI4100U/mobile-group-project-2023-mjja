// ## Acknowledgments
// The code in this project was developed with the assistance of ChatGPT, an AI language model created by OpenAI.

// the first page after signing into the app
//shows all the past transactions
//shows option to add transaction for new user

import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'custom_navigation.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../data/localDB/transaction.dart';

//for saving transaction data
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:share_extend/share_extend.dart';

final Color backgroundColor = Colors.black;
final Color purpleColor =
Color(0xFF5E17EB); // Replace with your exact color code
final Color textColor = Colors.white;

class Transaction_data{
  String? id;
  late String name;
  String? category;
  double? amount;
  DateTime? date;

  Transaction_data({
    this.id,
    required this.name,
    this.category,
    this.amount,
    this.date,
  });

  //get icons for each category
  IconData getIcon() {
    switch (category) {
      case 'Food':
        return Icons.fastfood;
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Travel':
        return Icons.travel_explore;
      case 'Bills':
        return Icons.money_outlined;
      case 'Education':
        return Icons.menu_book_rounded;
      case 'Subscriptions':
        return Icons.subscriptions;
      case 'Home':
        return Icons.home;
      case 'Income':
        return Icons.attach_money;
      default:
        return Icons.money_off;
    }
  }
}


//method to show expenses between date range selected
Future<DateTimeRange?> showCustomDateRangePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTimeRange? initialDateRange,
}) async {

  DateTimeRange? pickedRange;

  return showDialog<DateTimeRange>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height

          child: SfDateRangePicker(//Date picker to classify the transactions based on dates
            selectionMode: DateRangePickerSelectionMode.range,
            initialSelectedRange: PickerDateRange(
              initialDateRange?.start ?? firstDate,
              initialDateRange?.end ?? lastDate,
            ),
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              if (args.value is PickerDateRange) {
                final PickerDateRange range = args.value;
                pickedRange = DateTimeRange(
                  start: range.startDate!,
                  end: range.endDate ?? range.startDate!, // end date can be null if the same day is selected twice
                );
              }
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context, pickedRange);
            },
          ),
        ],
      );
    },
  );
}

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _selectedTransactionType = 'All'; // Default selection
  DateTimeRange? _selectedDateRange;
  final TransactionDatabase _expenseDatabase = TransactionDatabase();
  List<Transaction_data> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchAndSetExpenses(); // Fetch and set the expenses when the widget is initialized
  }

  Future<void> _fetchAndSetExpenses() async {
    final List<Transaction_data> expenses = await _fetchExpensesFromFirestore();
    setState(() {
      _transactions = expenses;
    });
  }

  String _convertTransactionsToCsv(List<Expense_data> transactions) {
    StringBuffer csvBuffer = StringBuffer();
    csvBuffer.writeln("ID,Name,Category,Amount,Date");
    for (var transaction in transactions) {
      csvBuffer.writeln('"${transaction.id}","${transaction.name}","${transaction.category}",'
          '"${transaction.amount}","${DateFormat('yyyy-MM-dd').format(transaction.date!)}"');
    }
    return csvBuffer.toString();
  }

  // Function to share the CSV file to external apps
  Future<void> _shareCsvFile() async {
    List<Expense_data> expenses = await _fetchExpensesFromFirestore();
    String csvData = _convertTransactionsToCsv(expenses);

    final directory = await getTemporaryDirectory(); // Use temporary directory for temporary file
    final path = '${directory.path}/expenses.csv';
    final file = File(path);
    await file.writeAsString(csvData);

    // Share the file with any app that can handle it
    Share.shareFiles([path], text: 'Here are your expenses in CSV format');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: SingleChildScrollView( // This makes your column scrollable
        child: Column(
          children: <Widget>[
            _buildTotalBalanceCard(_transactions),
            _buildTransactionTypeButtons(),
            _buildRecentTransactionsTitle(),
            _buildRecentTransactionList(),
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

  Widget _buildTotalBalanceCard(List<Transaction_data> transactions) {
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    // Calculate total income and total expense
    for (var transaction in transactions) {
      if (transaction.category == 'Income') {
        totalIncome += transaction.amount ?? 0.0;
      } else {
        totalExpense += transaction.amount ?? 0.0;
      }
    }

    double totalBalance = totalIncome - totalExpense;

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
                  Text('\$${totalBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold, color: purpleColor)
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Adjust this for different spacing effects
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.black),
                    onPressed: _shareCsvFile,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to build transaction type buttons with left alignment and smaller size
  Widget _buildTransactionTypeButtons() {
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
        primary: isSelected ? Colors.white : Color(0xFF5E17EB),
        // Background color
        onPrimary: isSelected ? Color(0xFF5E17EB) : Colors.white, // Text color
      ),
      onPressed: () {
        setState(() {
          _selectedTransactionType = type;
        });
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
          Text('Recent Transactions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),
          ),
          IconButton(
            // date picker to filter the transaction based on a range of dates.
            icon: Icon(Icons.date_range, color: Colors.white),
            onPressed: () async {
              DateTimeRange? pickedRange = await showCustomDateRangePicker(
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
    print("build transaction list is called");
    return FutureBuilder<List<Transaction_data>>(
        future: _fetchExpensesFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No transactions available.');
          } else {
            List<Transaction_data> transactions = snapshot.data ?? [];

    // Filter transactions based on the selected type i.e. All, Icome or Expense
    if (_selectedTransactionType != 'All') {
      bool isIncome = _selectedTransactionType == 'Income';
      transactions = transactions
          .where((tx) =>
              (isIncome && tx.category == 'Income') ||
              (!isIncome && tx.category != 'Income'))
          .toList();
    }

    // Filter transactions based on the selected date range
    if (_selectedDateRange != null) {
      transactions = transactions.where((tx) {
        DateTime txDate = tx.date!;
        return (txDate.isAfter(_selectedDateRange!.start) ||
            txDate.isAtSameMomentAs(_selectedDateRange!.start)) &&
            (txDate.isBefore(_selectedDateRange!.end.add(Duration(days: 1))) ||
                txDate.isAtSameMomentAs(_selectedDateRange!.end));
        }).toList();
    }

    // Group transactions by date to display on the screen
    Map<String, List<Transaction_data>> groupedTransactions = {};
    for (var transaction in transactions) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(transaction.date!);
      if (!groupedTransactions.containsKey(formattedDate)) {
        groupedTransactions[formattedDate] = [];
      }
      groupedTransactions[formattedDate]!.add(transaction);
    }

    List<String> sortedDates = groupedTransactions.keys.toList();
    sortedDates.sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));


    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sortedDates.length,
      //itemCount: groupedTransactions.entries.length,
      itemBuilder: (context, index) {
        String date = sortedDates[index];
        //String date = groupedTransactions.entries.elementAt(index).key;
        List<Transaction_data> dailyTransactions = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.parse(date)),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            ...dailyTransactions
                .map((transaction) => Container(
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
                          child:
                              Icon(transaction.getIcon(), color: Colors.black),
                        ),
                        title: Text(
                          transaction.name,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        subtitle: Text(
                          'Category: ${transaction.category}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          '${transaction.category == 'Income' ? '+' : '-'}\$${transaction.amount?.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: transaction.category == 'Income'
                                ? Colors.green
                                : Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ],
        );
      },
    );
  }
    }
  );
}
  Future<List<Transaction_data>> _fetchExpensesFromFirestore() async {
    try {
      return await _expenseDatabase.readAllTransactions();
    } catch (e) {
      print('Error fetching expenses from Firestore: $e');
      return [];
    }
  }
}
