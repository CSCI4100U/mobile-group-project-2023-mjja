import 'dart:typed_data';

class Category {
  int? id;
  String? name;
  Uint8List? icon;

  Category({
    this.id,
    this.name,
    this.icon,
  });

  // Generate a new Category object from a map, typically from the database
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'], // Assuming you store image data as Uint8List
    );
  }

  // Convert a Category object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon, // Assuming you store image data as Uint8List
    };
  }

  @override
  String toString() {
    return 'Category[id: $id, name: $name]';
  }
}
