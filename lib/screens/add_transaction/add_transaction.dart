import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/category.dart';
import '../../models/transaction.dart';
import '../../providers/category_provider.dart';
import '../../providers/transactions_provider.dart';
import '../../shared/forms/amount_form_field.dart';
import '../../shared/forms/category_form_field.dart';
import '../../shared/forms/date_form_field.dart';
import '../../shared/forms/transaction_form.dart';
import '../../shared/widgets/kspacer.dart';

class AddTransactionScreen extends ConsumerWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();
    TransactionType transactionType = TransactionType.expense;
    Category category = categories.first;
    num amount = 0;
    DateTime date = DateTime.now();
    String remarks = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TransactionTypeFormField(
                  onSaved: (t) => transactionType = t ?? transactionType,
                ),
                kSpacer,
                const Text('What did you spend on ?'),
                kSpacer,
                CategoryFormField(
                  context: context,
                  initialValue: category,
                  onSaved: (v) {
                    category = v ?? category;
                  },
                  categories: categories,
                ),
                kSpacer,
                const Text('How much did you spend ?'),
                kSpacer,
                AmountFormField(
                  theme: Theme.of(context),
                  onSaved: (v) {
                    amount = v ?? 0;
                  },
                  validator: (v) {
                    if (v == null) {
                      return 'Please enter a valid amount.';
                    }
                    if (v <= 0) {
                      return 'Amount should be greater then 0.';
                    }
                    if (transactionType == TransactionType.expense &&
                        v > category.availableBudget) {
                      return 'Amount greater than available budget.';
                    }
                    return null;
                  },
                ),
                kSpacer,
                const Text('When did you spend ?'),
                kSpacer,
                DateFormField(
                  context: context,
                  initialDate: DateTime.now(),
                  onSaved: (d) {
                    date = d ?? DateTime.now();
                  },
                ),
                kSpacer,
                const Text('Remarks'),
                kSpacer,
                TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: theme.colorScheme.secondary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: theme.colorScheme.secondary),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    hintText: 'Transaction Details',
                  ),
                  validator: (s) {
                    if (s == null || s.isEmpty) {
                      return 'Remarks cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (s) {
                    remarks = s ?? '';
                  },
                ),
                kSpacer,
                ElevatedButton(
                  onPressed: () {
                    formKey.currentState?.save();
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    final transaction = Transaction(
                      category,
                      remarks,
                      date,
                      amount,
                      transactionType,
                    );
                    ref
                        .read(transactionsProvider.notifier)
                        .addTransaction(transaction);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
