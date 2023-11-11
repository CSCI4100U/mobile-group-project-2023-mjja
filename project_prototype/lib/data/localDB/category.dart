import 'dart:typed_data';

enum CategoryType {
  Expense,
  Income,
}

class Category {
  int? id;
  String? name;
  Uint8List? icon;
  CategoryType type; // Enum to indicate whether it's an expense or income category

  Category({
    this.id,
    this.name,
    this.icon,
    required this.type,
  });

  // Generate a new Category object from a map, typically from the database
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'], // Assuming you store image data as Uint8List
      type: map['type'] == 'Expense' ? CategoryType.Expense : CategoryType.Income,
    );
  }

  // Convert a Category object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon, // Assuming you store image data as Uint8List
      'type': type == CategoryType.Expense ? 'Expense' : 'Income',
    };
  }

  @override
  String toString() {
    return 'Category[id: $id, name: $name, type: $type, icon: ${icon != null ? 'Icon Data' : 'No Icon'}]';
  }
}
