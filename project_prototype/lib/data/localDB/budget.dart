class Budget {
  String expenseCategory; // Category for which the budget is defined
  double amount; // Budget amount
  DateTime endDate; // Budget end date

  Budget({
    required this.expenseCategory,
    required this.amount,
    required this.endDate,
  });

  // Convert a Budget object to a map for data storage
  Map<String, dynamic> toMap() {
    return {
      'expenseCategory': expenseCategory,
      'amount': amount,
      'endDate': endDate.toIso8601String(),
    };
  }

  // Create a Budget object from a map
  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      expenseCategory: map['expenseCategory'],
      amount: map['amount'],
      endDate: DateTime.parse(map['endDate']),
    );
  }
}
