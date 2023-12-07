/// Allows user to enter details of new transactions when the user clicks on the "+" icon.
/// It saves the data of new transactions in the firebase.

import 'package:flutter/material.dart';
import 'package:money_minder/data/localDB/transaction.dart';
import 'package:money_minder/views/custom_navigation.dart';
import 'package:money_minder/views/transactions_page.dart';
import '../models/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Default design
final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

class AddTransactionForm extends StatefulWidget {
  final Function(Transaction) onExpenseAdded;

  AddTransactionForm({required this.onExpenseAdded});

  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

/// Displays the fields for user to enter transactions details
class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();
  final amountController = TextEditingController();

  final TransactionDatabase _transactionDatabase = TransactionDatabase();

  // Dropdown options for category
  List<String> categories = [
    'Food',
    'Shopping',
    'Travel',
    'Bills',
    'Education',
    'Subscriptions',
    'Home',
    'Income',
    'Other'
  ];

  // Selected category
  String? selectedCategory;

  /// Controllers for every fields
  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    categoryController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () {
                    // takes back to previous screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionsPage()
                      ),
                    );
                  },
                ),
                SizedBox(width: 8.0),
                Text(
                  "Add Transactions",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),

            //Starting form fields
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //name
                  TextFormField(
                    controller: nameController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Name *',
                      hintText: 'Enter name for the transaction.',
                      labelStyle: TextStyle(color: textColor),
                      hintStyle: TextStyle(color: textColor),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),

                  // Date Picker
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        dateController.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: dateController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Date *',
                          hintText: 'Select date of the transaction',
                          labelStyle: TextStyle(color: textColor),
                          hintStyle: TextStyle(color: textColor),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category *',
                      labelStyle: TextStyle(color: textColor),
                    ),
                    style: TextStyle(color: textColor),
                    dropdownColor: Colors.black,
                    value: selectedCategory,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),

                  // Amount
                  TextFormField(
                    controller: amountController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Amount (CAD)*',
                      hintText: '00.00',
                      labelStyle: TextStyle(color: textColor),
                      hintStyle: TextStyle(color: textColor),
                    ),
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // Convert the amount to double before saving to Firebase
                      if (value != null && value.isNotEmpty) {
                        amountController.value =
                        double.parse(value) as TextEditingValue;
                      }
                    },
                  ),
                  SizedBox(height: 20.0),

                  //Submit button
                  ElevatedButton(
                    onPressed: () {
                      // Validate each field has data before submitting
                      if (_formKey.currentState!.validate()) {
                        _saveTransactionToFirebase();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: purpleColor,
                      padding:
                      EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: textColor, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          // Handle bottom navigation bar item taps
        },
      )
    );
  }

  /// Save the transactions to firebase after clicking on Submit button
  Future<void> _saveTransactionToFirebase() async {
    //await _transactionDatabase.initializeDatabase();
    try {
      await _transactionDatabase.createTransaction(TransactionClass(
        name: nameController.text,
        category: selectedCategory,
        amount: double.parse(amountController.text),
        date: DateTime.parse(dateController.text),
      ));
    } catch (e) {
      print('Error saving transaction to Firebase: $e');
    }

    /// Routes back to main page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TransactionsPage()),
    );
  }
}
