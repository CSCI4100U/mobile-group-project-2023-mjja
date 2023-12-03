/**
 * Expense: this class store the expense information of the user.
 */
import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String? id;             // unique Expense identifier
  String? name;        // name of the expense
  String? category;    // category of the expense
  double? amount;      // amount of the expense
  DateTime? date;      // date of the Expense

  Expense({
    this.id,
    this.name,
    this.category,
    this.amount,
    this.date
  });

  // generate a new Expense object from a map, typically from the database
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
    );
  }

  // convert an Expense object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'name': name,
      'category': category,
      'amount': amount,
      'date': date?.toIso8601String(),
    };
  }

  factory Expense.fromSnapshot(DocumentSnapshot snapshot) {
    return Expense(
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
