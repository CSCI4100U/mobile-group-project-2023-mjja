class Income {
  int incomeId; // Unique income identifier
  String name; // Name of the income source
  double amount; // Amount of income
  DateTime date; // Date of income
  String description; // Description of the income
  int categoryId; // Category ID associated with this income

  Income({
    required this.incomeId,
    required this.name,
    required this.amount,
    required this.date,
    required this.description,
    required this.categoryId,
  });

  // Convert an Income object to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'incomeId': incomeId,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(), // Store the date as a string
      'description': description,
      'categoryId': categoryId,
    };
  }

  // Convert a Map to an Income object
  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      incomeId: map['incomeId'],
      name: map['name'],
      amount: map['amount'],
      date: DateTime.parse(map['date']), // Parse the stored date string
      description: map['description'],
      categoryId: map['categoryId'],
    );
  }
}
