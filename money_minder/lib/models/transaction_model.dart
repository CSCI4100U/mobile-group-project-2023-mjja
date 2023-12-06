// /**
//  * ExpenseDatabase: This class contains methods to perform CRUD operations on Expense class
//  */

import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/localDB/db_utils.dart';
import '../data/localDB/transaction.dart';
import '../views/transactions.dart';

class TransactionDatabase {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final dbUtils = DBUtils();

  // the colelction is already initialized in the firestore

  // Future<void> initializeDatabase() async {
  //   try {
  //     //  ensure that the collection 'expenses' exists.
  //     await _firestore.collection('transactions');
  //     print('Firestore collection initialized successfully');
  //   } catch (e) {
  //     print('Error initializing the Firestore collection: $e');
  //   }
  // }

  Future<void> createTransaction(TransactionClass transaction) async {
    print("inside create expense");
    try {
      // await initializeDatabase();
      print("before adding expense to Firestore: $transaction");
      await _firestore.collection('transactions').add(transaction.toMap());
      print("Expense added to Firestore successfully");
    } catch (e) {
      print('Error creating expense: $e');
    }
  }

  Future<List<Transaction_data>> readAllTransactions() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('transactions').get();
      List<TransactionClass> expenses = querySnapshot.docs.map((doc) => TransactionClass.fromSnapshot(doc)).toList();

      List<Transaction_data> expenseDataList = expenses.map((expense) {
        return Transaction_data(
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

  Future<void> updateTransactions(TransactionClass expense) async {
    try {
      await _firestore.collection('transactions').doc(expense.id).update(expense.toMap());
    } catch (e) {
      print('Error updating expense: $e');
    }
  }

  Future<void> deleteTransactions(String id) async {
    try {
      await _firestore.collection('transactions').doc(id).delete();
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }
}
