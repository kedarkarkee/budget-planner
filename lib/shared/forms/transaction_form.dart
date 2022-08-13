import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/transaction.dart';
import '../widgets/tab_card.dart';

class TransactionTypeFormField extends FormField<TransactionType> {
  TransactionTypeFormField({
    Key? key,
    required FormFieldSetter<TransactionType> onSaved,
  }) : super(
          key: key,
          initialValue: TransactionType.expense,
          onSaved: onSaved,
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
