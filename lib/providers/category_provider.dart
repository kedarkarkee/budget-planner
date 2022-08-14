import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';

final categoriesProvider =
    StateNotifierProvider<CategoryProvider, List<Category>>(
  (ref) {
    return CategoryProvider();
  },
);

class CategoryProvider extends StateNotifier<List<Category>> {
  CategoryProvider()
      : super(<Category>[
          Category('Food and Drinks', Icons.restaurant, Colors.blue),
          Category('Transportation', Icons.bus_alert, Colors.purple),
          Category('Utilities', Icons.settings, Colors.amber),
          Category('Education', Icons.menu_book, Colors.green),
          Category('Rent', Icons.home, Colors.indigo),
          Category(
            'Health',
            Icons.favorite,
            Colors.red,
          ),
          Category(
            'Miscellaneous',
            Icons.tune,
            Colors.lime,
          ),
        ]);

  void addCategory(Category c) {
    state = [...state, c];
  }

  void resetCategory() {
    state = [
      Category('Food and Drinks', Icons.restaurant, Colors.blue),
      Category('Transportation', Icons.bus_alert, Colors.purple),
      Category('Utilities', Icons.settings, Colors.amber),
      Category('Education', Icons.menu_book, Colors.green),
      Category('Rent', Icons.home, Colors.indigo),
      Category(
        'Health',
        Icons.favorite,
        Colors.red,
      ),
      Category(
        'Miscellaneous',
        Icons.tune,
        Colors.lime,
      ),
    ];
  }

  void addExpense(String title, num amount) {
    final c = state.indexWhere((element) => element.title == title);
    if (c != -1) {
      state[c].spent += amount;
    }
  }

  void addIncome(String title, num amount) {
    final c = state.indexWhere((element) => element.title == title);
    if (c != -1) {
      state[c].budget += amount;
    }
  }

  num get totalBudget {
    num b = 0;
    for (final c in state) {
      b += c.budget;
    }
    return b;
  }

  num get totalSpent {
    num b = 0;
    for (final c in state) {
      b += c.spent;
    }
    return b;
  }
}
