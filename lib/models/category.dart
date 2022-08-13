import 'package:flutter/material.dart';

class Category {
  final String title;
  final IconData icon;
  final Color color;
  num budget = 0;
  num spent = 0;

  Category(this.title, this.icon, this.color);

  num get availableBudget => budget - spent;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'icon': icon.codePoint});
    result.addAll({'color': color.value});
    result.addAll({'budget': budget});
    result.addAll({'spent': spent});

    return result;
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    final c = Category(
      map['title'] ?? '',
      IconData(map['icon'], fontFamily: 'MaterialIcons'),
      Color(map['color']),
    );
    c.budget = map['budget'] ?? 0;
    c.spent = map['spent'] ?? 0;
    return c;
  }
}

// final categoriesss = [
//   Category('Food and Drinks', Icons.restaurant, Colors.blue, 20000),
//   Category('Transportation', Icons.bus_alert, Colors.purple, 10000),
//   Category('Utilities', Icons.settings, Colors.amber, 8000),
//   Category('Education', Icons.menu_book, Colors.green, 30000),
//   Category('Health', Icons.favorite, Colors.red, 10000),
//   Category('Miscellaneous', Icons.tune, Colors.lime, 15000),
// ];
