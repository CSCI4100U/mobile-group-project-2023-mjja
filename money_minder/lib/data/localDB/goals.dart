class Goal {
  int? id;
  String name;
  double amount;
  DateTime endDate;

  Goal({
    this.id,
    required this.name,
    required this.amount,
    required this.endDate,
  });

  // create a Goal object from a map
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      endDate: DateTime.parse(map['endDate']),
    );
  }

  // convert a Goal object to a map for data storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'endDate': endDate.toIso8601String(),
    };
  }
}
