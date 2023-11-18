class Goal {
  String name;
  double amount;
  DateTime endDate;

  Goal({
    required this.name,
    required this.amount,
    required this.endDate,
  });

  // Convert a Goal object to a map for data storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'endDate': endDate.toIso8601String(),
    };
  }

  // Create a Goal object from a map
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      name: map['name'],
      amount: map['amount'],
      endDate: DateTime.parse(map['endDate']),
    );
  }
}
