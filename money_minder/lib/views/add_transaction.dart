//Code to enter details of any transactions when the user clicks on the "+" icon

import 'package:flutter/material.dart';
import 'package:money_minder/data/localDB/transaction.dart';
import 'package:money_minder/views/custom_navigation.dart';
import 'package:money_minder/views/transactions_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/transaction_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

class AddTransactionForm extends StatefulWidget {
  final Function(Transaction) onExpenseAdded;

  AddTransactionForm({required this.onExpenseAdded});

  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

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

  //controllers for every fields
  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    categoryController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _saveExpenseToFirebase() async {
    print("inside save transaction to firebase method");

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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TransactionsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: CustomAppBar(),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Back Arrow and Title
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.grey), // Adjust color accordingly
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionsPage()),
                      );
                    },
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    AppLocalizations.of(context)!.add_transaction,
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: purpleColor), // Adjust styling as needed
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      //name
                      TextFormField(
                        controller: nameController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.name_star,
                          hintText: AppLocalizations.of(context)!.enter_where,
                          labelStyle: TextStyle(color: textColor),
                          hintStyle: TextStyle(color: textColor),
                          suffix: Text(
                            '*', // Red star indicating required field
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.this_field_req;
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
                              labelText:
                                  AppLocalizations.of(context)!.date_star,
                              hintText: 'Select the date of the transaction',
                              labelStyle: TextStyle(color: textColor),
                              hintStyle: TextStyle(color: textColor),
                              suffix: Text(
                                '*', // Red star indicating required field
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .this_field_req;
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
                          labelText:
                              AppLocalizations.of(context)!.category_star,
                          labelStyle: TextStyle(color: textColor),
                          suffix: Text(
                            '*', // Red star indicating required field
                            style: TextStyle(color: Colors.red),
                          ),
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
                            return AppLocalizations.of(context)!.this_field_req;
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
                          labelText: AppLocalizations.of(context)!.amount_star,
                          hintText: '0.00',
                          labelStyle: TextStyle(color: textColor),
                          hintStyle: TextStyle(color: textColor),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.this_field_req;
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
                          // Validate the form before submitting
                          if (_formKey.currentState!.validate()) {
                            _saveExpenseToFirebase();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: purpleColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.submit,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {
            // Handle bottom navigation bar item taps
          },
        ));
  }
}
