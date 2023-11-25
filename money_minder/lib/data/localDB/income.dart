/**
 * Income: this class stores the income information of the user.
 */


class Income {
  int? id;          // unique Income identifier
  String? name;     // name of the income source
  double? amount;   // amount of income
  DateTime? date;   // date of income

  Income({
    this.id,
    this.name,
    this.amount,
    this.date,
  });

  // generate a new Income object from a map, typically from the database
  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }

  // convert an Income object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Income [id: $id, name: $name, amount: $amount, date: $date]';
  }

}
