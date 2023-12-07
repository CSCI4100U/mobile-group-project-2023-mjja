/// Displays:
///   Total balance: TotalIncome - Total Expense
///   Export button to save transactions as CSV
///   Allows sorting by:
///     - All transactions, only incomes, only expenses
///     - All transactions between range of dates selected from date picker
///   All the past transactions - name, category, amount, and, date directly from Firebase

//all necessary imports
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'custom_navigation.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Default UI features and colours
final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

/// Transaction_data class to initialize all required variables
class Transaction_data {
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

/// Method to show transactions between date range selected from the date picker
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
          height:
              MediaQuery.of(context).size.height * 0.5, // 50% of screen height

          child: SfDateRangePicker(
            //Date picker to classify the transactions based on dates
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
                  end: range.endDate ??
                      range
                          .startDate!, // end date can be null if the same day is selected twice
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

/// Displays all the past transactions
class _TransactionsPageState extends State<TransactionsPage> {
  String _selectedTransactionType = 'All'; // Default selection
  DateTimeRange? _selectedDateRange;
  final TransactionDatabase _expenseDatabase = TransactionDatabase();
  List<Transaction_data> _transactions =
      []; // initializing the transaction list

  @override
  void initState() {
    super.initState();
    _fetchAndSetExpenses(); // Fetch and set the expenses when the widget is initialized
  }

  /// Fetches all the transaction data entered in add_transaction form from Firebase to fill out the UI.
  Future<List<Transaction_data>> _fetchExpensesFromFirestore() async {
    try {
      return await _expenseDatabase.readAllTransactions();
    } catch (e) {
      print('Error fetching expenses from Firestore: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        // This makes your column scrollable
        child: Column(
          children: <Widget>[
            // Different build widgets for different sections of the screen
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

  /// Fetch transactions list
  Future<void> _fetchAndSetExpenses() async {
    final List<Transaction_data> transactions =
        await _fetchExpensesFromFirestore();
    setState(() {
      _transactions = transactions;
    });
  }

  /// Method called when exporting the transactions.
  /// Converts the list of transactions into a CSV file format
  // Transaction information conversion was developed with the assistance of ChatGPT - OpenAI
  String _convertTransactionsToCsv(List<Transaction_data> transactions) {
    StringBuffer csvBuffer = StringBuffer();
    csvBuffer.writeln("Name,Category,Amount,Date");
    // format all transactions in the desired format
    for (var transaction in transactions) {
      csvBuffer.writeln(
          '"${transaction.name}","${transaction.category}",'
          '"${transaction.amount}","${DateFormat('yyyy-MM-dd').format(transaction.date!)}"');
    }
    return csvBuffer.toString();
  }

  /// Function to share the CSV file to external apps(eg. Google Drive and Email)
  Future<void> _shareCsvFile() async {
    List<Transaction_data> transactions = await _fetchExpensesFromFirestore();
    String csvData = _convertTransactionsToCsv(transactions);

    // Use temporary directory for temporary file (uses path_provider)
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/transactions.csv';
    final file = File(path);
    // Write the formatted transaction list into the .csv file
    await file.writeAsString(csvData);

    // Share/upload the file through apps that are compatible with the device
    Share.shareFiles([path], text: 'Here are my transactions in CSV format');
  }

  /// Shows the total balance left at the top by calculating totalIncome - totalExpenses, also allows exporting of the transactions.
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
                  Text('Total Balance:', style: TextStyle(color: Colors.black)),
                  Text('\$${totalBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: purpleColor
                    )
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Adjust this for different spacing effects
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

  /// Builds transaction type buttons, which when clicked on, changes the Transaction list
  Widget _buildTransactionTypeButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Left align the buttons
        children: <Widget>[
          _transactionTypeButton('All'),
          SizedBox(width: 4),
          _transactionTypeButton('Income'),
          SizedBox(width: 4),
          _transactionTypeButton('Expense'),
        ],
      ),
    );
  }

  /// Changes the design of buttons when clicked on it and pass the selected type to filter the transactions
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

  /// Builds the "Recent Transaction" title and shows a date picker icon, which allows to select a date range, and update UI based on date range
  Widget _buildRecentTransactionsTitle() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          IconButton(
            // date picker to filter the transaction based on a range of dates.
            icon: Icon(Icons.date_range, color: textColor),
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

  /// Builds the transactions list, also updates it when the user enters new transactions
  Widget _buildRecentTransactionList() {
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

          // Filter transactions based on the selected type i.e. All, Income or Expense
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
                        (txDate.isBefore(
                          _selectedDateRange!.end.add(Duration(days: 1))) ||
                      txDate.isAtSameMomentAs(_selectedDateRange!.end));
            }).toList();
          }

          // Group transactions by date to display on the screen
          Map<String, List<Transaction_data>> groupedTransactions = {};
          for (var transaction in transactions) {
            String formattedDate =
                DateFormat('yyyy-MM-dd').format(transaction.date!);
            if (!groupedTransactions.containsKey(formattedDate)) {
              groupedTransactions[formattedDate] = [];
            }
            groupedTransactions[formattedDate]!.add(transaction);
          }

          List<String> sortedDates = groupedTransactions.keys.toList();
          sortedDates
              .sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

          //Builds each tile to display the info of transactions
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              String date = sortedDates[index];
              List<Transaction_data> dailyTransactions =
                  groupedTransactions[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    // show the date of the transaction
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('EEEE, MMMM dd, yyyy')
                          .format(DateTime.parse(date)),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                  ),

                  // show info about each transaction, categorized date wise
                  ...dailyTransactions.map((transaction) {
                    // allows to delete any particular transaction with a swipe or a by clicking on a popup menu that appears when clicking on the transaction.
                    return GestureDetector(
                      onTap: () async {
                        await showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(0, 50, 0, 0),
                          items: [
                            PopupMenuItem(
                              child: ListTile(
                                leading: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                                title: Text('Delete'),
                                onTap: () {
                                  // Remove the item from the database and update the UI
                                  _expenseDatabase
                                      .deleteTransactions(transaction.id!);
                                  setState(() {
                                    _transactions.remove(transaction);
                                  });

                                  // Show a snackbar to indicate the transaction is deleted
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: purpleColor,
                                      content: Text('Transaction deleted'),
                                    ),
                                  );
                                  Navigator.pop(context); // Close the menu
                                },
                              ),
                            ),
                          ],
                          elevation: 8.0,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Dismissible(
                          key: Key(transaction.id!),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            // Remove the item from the database and update the UI
                            _expenseDatabase
                                .deleteTransactions(transaction.id!);
                            setState(() {
                              _transactions.remove(transaction);
                            });

                            // Show a snackbar to indicate the transaction is deleted
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: purpleColor,
                                content: Text('Transaction deleted'),
                              ),
                            );
                          },
                          child: ListTile(
                            tileColor: Colors.white,
                            // design for icon for transactions
                            leading: CircleAvatar(
                              backgroundColor: Color(0xFFFFECB3),
                              child: Icon(transaction.getIcon(),
                                  color: Colors.black),
                            ),
                            title: Text(
                              // displays name of the transaction
                              transaction.name,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              // adds category of transaction
                              'Category: ${transaction.category}',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            trailing: Text(
                              // shows amount of the transaction
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
                        ),
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          );
        }
      });
  }
}
