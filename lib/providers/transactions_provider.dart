import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '../models/transaction.dart';
import '../utils/extensions.dart';
import 'category_provider.dart';

final transactionsProvider =
    StateNotifierProvider<_TransactionsProvider, List<Transaction>>(
  (ref) {
    final notifier = ref.read(categoriesProvider.notifier);
    return _TransactionsProvider(notifier)..loadTransactionFromCache();
  },
);

class _TransactionsProvider extends StateNotifier<List<Transaction>> {
  _TransactionsProvider(this.categoryProvider) : super(<Transaction>[]);
  static const _kTxKey = 'transactions';
  final box = GetStorage();
  final CategoryProvider categoryProvider;

  void addRandomTransactions() {
    final start = DateTime.now().subtract(const Duration(days: 30));
    final days =
        List.generate(32, (i) => DateTime(2022, start.month, start.day + (i)));
    for (final d in days) {
      final ctgry = categoryProvider.state.randomItem;
      final amt = Random().nextInt(10000);
      final iTxn = Transaction(
        ctgry,
        'Some Income Remarks',
        d,
        amt + Random().nextInt(500) + 2000,
        TransactionType.income,
      );
      addTransaction(iTxn, false);
      final eTxn = Transaction(
        ctgry,
        'Some Expense Remarks',
        d,
        amt + Random().nextInt(1000),
        TransactionType.expense,
      );
      addTransaction(eTxn, false);
    }
    updateCache();
  }

  void deleteAllRecords() {
    state = [];
    updateCache();
    categoryProvider.resetCategory();
  }

  void loadTransactionFromCache() {
    final cacheTxs = box.read<List>(_kTxKey) ?? [];
    for (final t in cacheTxs) {
      addTransaction(Transaction.fromMap(t as Map<String, dynamic>));
    }
  }

  void updateCategory(Transaction transaction, [bool subtract = false]) {
    if (transaction.transactionType == TransactionType.expense) {
      categoryProvider.addExpense(
        transaction.category.title,
        subtract ? -transaction.amount : transaction.amount,
      );
    } else {
      categoryProvider.addIncome(
        transaction.category.title,
        subtract ? -transaction.amount : transaction.amount,
      );
    }
  }

  void addTransaction(Transaction transaction, [bool updateC = true]) {
    updateCategory(transaction);
    state = [...state, transaction];
    if (updateC) {
      updateCache();
    }
  }

  Future<void> updateCache() async {
    await box.write(_kTxKey, state.map((e) => e.toMap()).toList());
  }

  void deleteTransaction(Transaction t) {
    final reqTxn = state.indexWhere(
      (element) =>
          element.date.millisecondsSinceEpoch == t.date.millisecondsSinceEpoch,
    );
    if (reqTxn != -1) {
      updateCategory(state[reqTxn], true);
      final extState = [...state];
      state = extState..removeAt(reqTxn);
    }
    updateCache();
  }
}
