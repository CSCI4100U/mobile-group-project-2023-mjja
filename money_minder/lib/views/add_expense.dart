import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB); // Replace with your exact color code
final Color textColor = Colors.white;

class AddExpenseForm extends StatefulWidget {
  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  // Dropdown options for category
  List<String> categories = [
    'Food',
    'Shopping',
    'Travel',
    'Bills',
    'Education',
    'Subscriptions',
    'Home',
    'Other',
  ];

  // Selected category
  String? selectedCategory;

  @override
  void dispose() {
    dateController.dispose();
    categoryController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
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
                          labelText: 'Date',
                          hintText: 'Select the date of the expense',
                          labelStyle: TextStyle(color: textColor),
                          hintStyle: TextStyle(color: textColor),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
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
                  ),
                  SizedBox(height: 20.0),
                  // Amount
                  TextFormField(
                    controller: amountController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter the amount of the expense',
                      labelStyle: TextStyle(color: textColor),
                      hintStyle: TextStyle(color: textColor),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 20.0),
                  // Description
                  TextFormField(
                    controller: descriptionController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter a description of the expense',
                      labelStyle: TextStyle(color: textColor),
                      hintStyle: TextStyle(color: textColor),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add your submit logic here
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