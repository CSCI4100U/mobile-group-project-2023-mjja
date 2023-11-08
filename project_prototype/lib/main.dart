import 'package:flutter/material.dart';

import 'data/localDB/expenses.dart';
import 'models/expense_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Money Minder'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final expense = Expense(
                name: 'Groceries',
                category: 'Food',
                amount: 50.0,
                date: '2023/11/07',
                description: 'Monthly grocery shopping',
              );

              final db = ExpenseDatabase();
              await db.createExpense(expense);

              final expenses = await db.readAllExpenses();
              for (final exp in expenses) {
                print('************ Expense: ${exp.name}, Amount: ${exp.amount}');
              }
            },
            child: Text('Test Local Database'),
          ),
        ),
      ),
    );
  }
}