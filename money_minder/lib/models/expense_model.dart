// /**
//  * ExpenseDatabase: This class contains methods to perform CRUD operations on Expense class
//  */

import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/localDB/db_utils.dart';
import '../data/localDB/expense.dart';
import '../views/expenses.dart';

class ExpenseDatabase {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final dbUtils = DBUtils();

  // Future<void> initializeDatabase() async {
  //   try {
  //     //  ensure that the collection 'expenses' exists.
  //     await _firestore.collection('expenses').doc('default_data')
  //         .set({
  //       'name': 'FreshCo',
  //       'category': 'Shopping',
  //       'amount': 45.90,
  //       'date': '2023-11-19'});
  //     print('Firestore collection initialized successfully');
  //   } catch (e) {
  //     print('Error initializing the Firestore collection: $e');
  //   }
  // }

  Future<void> createExpense(Expense expense) async {
    print("inside create expense");
    try {
      //await initializeDatabase();
      print("before adding expense to Firestore: $expense");
      await _firestore.collection('expenses').add(expense.toMap());
      print("Expense added to Firestore successfully");
    } catch (e) {
      print('Error creating expense: $e');
    }
  }

  Future<List<Expense_data>> readAllExpenses() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('expenses').get();
      List<Expense> expenses = querySnapshot.docs.map((doc) => Expense.fromSnapshot(doc)).toList();

      // Convert List<Expense> to List<Expense_data>
      List<Expense_data> expenseDataList = expenses.map((expense) {
        return Expense_data(
          id: expense.id,
          name: expense.name!,
          category: expense.category,
          amount: expense.amount,
          date: expense.date,
        );
      }).toList();

      return expenseDataList;
    } catch (e) {
      print('Error reading expenses: $e');
      return [];
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _firestore.collection('expenses').doc(expense.id).update(expense.toMap());
    } catch (e) {
      print('Error updating expense: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _firestore.collection('expenses').doc(id).delete();
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }
}
