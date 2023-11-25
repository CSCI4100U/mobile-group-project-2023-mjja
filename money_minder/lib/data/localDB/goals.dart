/**
 * Goal: this class store the goal information of the user.
 */

class Goal {
  int? id;              // unique Goal identifier
  String? name;         // name of the goal
  double? amount;       // amount of the goal
  DateTime? endDate;    // end date for the goal

  Goal({
    this.id,
    this.name,
    this.amount,
    this.endDate,
  });

  // generate a new Goal object from a map, typically from the database
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      endDate: DateTime.parse(map['endDate']),
    );
  }

  // convert a Goal object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Goal [id: $id, name: $name, amount: $amount, date: $endDate]';
  }
}
