/**
 * Category: this class store the category information for the income and expenses
 */

import 'dart:typed_data';

class Category {
  int? id;            // unique Category identifier
  String? name;       // Name of the category
  Uint8List? icon;    // category icon

  Category({
    this.id,
    this.name,
    this.icon,
  });

  // generate a new Category object from a map, typically from the database
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'], // assuming you store image data as Uint8List
    );
  }

  // convert a Category object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon, // assuming you store image data as Uint8List
    };
  }

  @override
  String toString() {
    return 'Category[id: $id, name: $name]';
  }
}
