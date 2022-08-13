import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class DateFormField extends FormField<DateTime> {
  DateFormField({
    Key? key,
    required BuildContext context,
    required DateTime initialDate,
    required FormFieldSetter<DateTime> onSaved,
  }) : super(
          key: key,
          initialValue: initialDate,
          onSaved: onSaved,
          builder: (state) {
            final theme = Theme.of(context);
            return TextField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.secondary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.secondary),
                ),
                hintText: state.value?.readableFormat,
              ),
              keyboardType: TextInputType.datetime,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  initialDate: initialDate,
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  state.didChange(date);
                }
              },
            );
          },
        );
}
