/**
 * Budget: this class store the budget information of the user.
 */

class Budget {
  int? id;              // unique Budget identifier
  String? name;         // name of the budget
  String? category;     // category for the budget
  double? amount;       // budget amount
  DateTime? endDate;    // budget end date

  Budget({
    this.id,
    this.name,
    this.category,
    this.amount,
    this.endDate,
  });

  // generate a new Budget object from a map, typically from the database
  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      amount: map['amount'],
      endDate: DateTime.parse(map['endDate']),
    );
  }

  // convert an Budget object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'category': category,
      'amount': amount,
      'endDate': endDate?.toIso8601String(),
    };
  }


  @override
  String toString() {
    return 'Budget [id: $id, name: $name, category: $category, amount: $amount, date: $endDate]';
  }

}
