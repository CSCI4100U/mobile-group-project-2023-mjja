/// Expense: this class store the transaction information of the user.

import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionClass {
  String? id;             // unique Expense identifier
  String? name;        // name of the expense
  String? category;    // category of the expense
  double? amount;      // amount of the expense
  DateTime? date;      // date of the Expense

  TransactionClass({
    this.id,
    this.name,
    this.category,
    this.amount,
    this.date
  });

  factory TransactionClass.fromMap(Map<String, dynamic> map) {
    return TransactionClass(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'name': name,
      'category': category,
      'amount': amount,
      'date': date?.toIso8601String(),
    };
  }

  factory TransactionClass.fromSnapshot(DocumentSnapshot snapshot) {
    return TransactionClass(
      id: snapshot.id,
      name: snapshot['name'],
      category: snapshot['category'],
      amount: snapshot['amount'],
      date: DateTime.parse(snapshot['date']),
    );
  }

  @override
  String toString() {
    return 'Expense[id: $id, name: $name, category: $category, amount: $amount, date: $date]';
  }
}
