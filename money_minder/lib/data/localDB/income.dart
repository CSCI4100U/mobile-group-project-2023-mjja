class Income {
  int id; // Unique income identifier
  String name; // Name of the income source
  double amount; // Amount of income
  DateTime date; // Date of income


  Income({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });

  // Convert an Income object to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(), // Store the date as a string
    };
  }

  // Convert a Map to an Income object
  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      date: DateTime.parse(map['date']), // Parse the stored date string
    );
  }
}
