import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/add_transaction/add_transaction.dart';
import 'screens/dashboard/dashboard.dart';
import 'screens/set_budget/set_budget.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: Colors.orange,
              secondary: Colors.orange,
            ),
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              centerTitle: true,
              elevation: 0,
              foregroundColor: Colors.black,
              backgroundColor: ThemeData.light().scaffoldBackgroundColor,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shadowColor: Colors.transparent,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: const BorderSide(color: Colors.orange),
          ),
        ),
      ),
      routes: {
        '/': (ctx) => const DashboardScreen(),
        '/add-transaction': (ctx) => const AddTransactionScreen(),
        '/set-budget': (ctx) => const SetBudget(),
      },
    );
  }
}
