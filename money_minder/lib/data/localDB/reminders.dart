/// Reminders: this class store the reminder information of the user.

class Reminder {
  int? id;              // unique Reminder identifier
  String? title;         // name of the reminder
  String? description;  // description of the reminder
  DateTime? endDate;    // end date for the reminder
  int? isCompleted;     // is reminder completed
  int? isUrgent;

  Reminder({
    this.id,
    this.title,
    this.description,
    this.endDate,
    this.isCompleted,
    this.isUrgent,
  });

  // generate a new Reminders object from a map, typically from the database
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description : map['description'],
      endDate: DateTime.parse(map['endDate']),
      isCompleted: map['isCompleted'],
      isUrgent: map['isUrgent'],
    );
  }

  // convert Reminders object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'endDate': endDate?.toIso8601String(),
      'isCompleted': isCompleted, // SQLite doesn't have a boolean type, use 0 or 1
      'isUrgent' : isUrgent,
    };
  }

  Reminder copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? endDate,
    int? isCompleted,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'Reminder [id: $id, title: $title, description: $description, date: $endDate, isUrgent: $isUrgent, isCompleted : $isCompleted]';
  }
}
