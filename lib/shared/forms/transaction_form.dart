import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/transaction.dart';
import '../widgets/tab_card.dart';

class TransactionTypeFormField extends FormField<TransactionType> {
  TransactionTypeFormField({
    super.key,
    required FormFieldSetter<TransactionType> super.onSaved,
  }) : super(
          initialValue: TransactionType.expense,
          builder: (state) {
            return Row(
              children: TransactionType.values.reversed
                  .map(
                    (e) => Expanded(
                      child: TabCard(
                        isActive: e == state.value,
                        title: toBeginningOfSentenceCase(e.name) ?? e.name,
                        onTap: () {
                          state.didChange(e);
                        },
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        );
}
