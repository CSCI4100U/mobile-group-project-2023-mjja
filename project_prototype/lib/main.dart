import 'package:flutter/material.dart';

//firebase dependencies
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'data/localDB/expenses.dart';
import 'models/expense_model.dart';

void main() => runApp(MyApp());

/////////   SQLite test code ////////////////
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

//////////  FIREBASE TEST DATA///////////////////////

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
//
// class MyApp extends StatelessWidget {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Money Minder'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               final expenseData = {
//                 'name': 'Groceries',
//                 'category': 'Food',
//                 'amount': 50.0,
//                 'date': '2023/11/07',
//                 'description': 'Monthly grocery shopping',
//               };
//
//               // Reference to the 'expenses' collection
//               final CollectionReference expensesCollection = firestore.collection('expenses');
//
//               // Add an expense to the Firestore collection
//               await expensesCollection.add(expenseData);
//
//               // Query the Firestore collection to retrieve expenses
//               final QuerySnapshot expensesQuery = await expensesCollection.get();
//
//               for (final QueryDocumentSnapshot doc in expensesQuery.docs) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 print('************ Expense: ${data['name']}, Amount: ${data['amount']}');
//               }
//             },
//             child: const Text('Test Firebase Database'),
//           ),
//         ),
//       ),
//     );
//   }
// }


//////////////Firebase test code ends ///////////////////////////////////////