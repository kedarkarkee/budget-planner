import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '../models/transaction.dart';
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

  void addTransaction(Transaction transaction) {
    updateCategory(transaction);
    state = [...state, transaction];

    updateCache();
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
