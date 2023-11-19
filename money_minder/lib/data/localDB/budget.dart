class Budget {
  int? id;
  String expenseCategory; // Category for which the budget is defined
  double amount; // Budget amount
  DateTime endDate; // Budget end date

  Budget({
    this.id,
    required this.expenseCategory,
    required this.amount,
    required this.endDate,
  });

  // create a Budget object from a map
  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      expenseCategory: map['expenseCategory'],
      amount: map['amount'],
      endDate: DateTime.parse(map['endDate']),
    );
  }

  // convert a Budget object to a map for data storage
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'expenseCategory': expenseCategory,
      'amount': amount,
      'endDate': endDate.toIso8601String(),
    };
  }
}
