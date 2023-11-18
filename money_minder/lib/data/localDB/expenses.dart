class Expense {
  int? id;
  String? name;
  String? category;
  double? amount;
  String? date;
  String description;

  Expense({
    this.id,
    this.name,
    this.category,
    this.amount,
    this.date,
    required this.description
  });

  // Generate a new Expense object from a map, typically from the database
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'], // != null ? DateTime.parse(map['date']) : null,
      description: map['description'],
    );
  }

  // Convert an Expense object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'amount': amount,
      'date': date,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Expense[id: $id, name: $name, category: $category, amount: $amount, date: $date, description: $description]';
  }
}
