/// TransactionDatabase: This class contains methods to perform CRUD operations on Transaction class

import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/localDB/db_utils.dart';
import '../data/localDB/transaction.dart';
import '../views/transactions_page.dart';

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

  // create new transaction
  Future<void> createTransaction(TransactionClass transaction) async {
    print("inside create expense");
    try {
      // await initializeDatabase();
      await _firestore.collection('transactions').add(transaction.toMap());
    } catch (e) {
      print('Error creating expense: $e');
    }
  }

  //read all transactions
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

  //delete all transactions
  Future<void> deleteTransactions(String id) async {
    try {
      await _firestore.collection('transactions').doc(id).delete();
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }
}
