/// Goal: this class store the goal information of the user.

class Goal {
  int? id;              // unique Goal identifier
  String? name;         // name of the goal
  String? description;  // description of the goal
  double? amount;       // amount of the goal
  DateTime? endDate;    // end date for the goal
  int? isCompleted;     // is goal completed

  Goal({
    this.id,
    this.name,
    this.description,
    this.amount,
    this.endDate,
    this.isCompleted,
  });

  // generate a new Goal object from a map, typically from the database
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      name: map['name'],
      description : map['description'],
      amount: map['amount'],
      endDate: DateTime.parse(map['endDate']),
      isCompleted: map['isCompleted'],
    );
  }

  // convert a Goal object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'endDate': endDate?.toIso8601String(),
      'isCompleted': isCompleted, // SQLite doesn't have a boolean type, use 0 or 1
    };
  }

  @override
  String toString() {
    return 'Goal [id: $id, name: $name, description: $description, amount: $amount, date: $endDate, isCompleted: $isCompleted]';
  }
}
