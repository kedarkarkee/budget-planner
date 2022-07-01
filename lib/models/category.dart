import 'package:flutter/material.dart';

class Category {
  final String title;
  final IconData icon;
  final Color color;

  const Category(this.title, this.icon, this.color);
}

const categories = [
  Category('Food and Drinks', Icons.food_bank, Colors.blue),
  Category('Transportation', Icons.bus_alert, Colors.purple),
  Category('Utilities', Icons.settings, Colors.amber),
  Category('Education', Icons.notes, Colors.green),
  Category('Health', Icons.favorite, Colors.red),
];
