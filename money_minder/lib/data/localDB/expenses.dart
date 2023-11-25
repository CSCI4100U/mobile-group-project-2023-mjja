class Expense {
  int? id;
  String? name;
  String? category;
  double? amount;
  DateTime? date;

  Expense({
    this.id,
    this.name,
    this.category,
    this.amount,
    this.date,
  });

  // Generate a new Expense object from a map, typically from the database
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }

  // Convert an Expense object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'amount': amount,
      'date': date?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Expense[id: $id, name: $name, category: $category, amount: $amount, date: $date]';
  }
}
