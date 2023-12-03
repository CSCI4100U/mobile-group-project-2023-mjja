//Code to enter details of any transactions when the user clicks on the "+" icon

import 'package:flutter/material.dart';
import 'package:money_minder/data/localDB/expense.dart';
import 'package:money_minder/views/expenses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/expense_model.dart';


final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

class AddExpenseForm extends StatefulWidget {
  final Function(Expense) onExpenseAdded;

  AddExpenseForm({required this.onExpenseAdded});

  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();
  final amountController = TextEditingController();

  final ExpenseDatabase _expenseDatabase = ExpenseDatabase();

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
    print("inside save expense to firebase emthod");
    try {
      await _expenseDatabase.createExpense(Expense(
        name: nameController.text,
        category: selectedCategory,
        amount: double.parse(amountController.text),
        date: DateTime.parse(dateController.text),
      ));

    } catch (e) {
      print('Error saving expense to Firebase: $e');
    }

  Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => ExpensesPage()),
  );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Add Expense',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: purpleColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the ExpensePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ExpensesPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //name
                  TextFormField(
                    controller: nameController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Name *',
                      hintText: 'Enter where you did the transaction.',
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
                        dateController.text = pickedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: dateController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Date *',
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
                      hintText: '0.00',
                      labelStyle: TextStyle(color: textColor),
                      hintStyle: TextStyle(color: textColor),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // Convert the amount to double before saving to Firebase
                      if (value != null && value.isNotEmpty) {
                        amountController.value = double.parse(value) as TextEditingValue;
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
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
