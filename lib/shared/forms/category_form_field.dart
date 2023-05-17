import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../utils/extensions.dart';

class CategoryFormField extends FormField<Category> {
  CategoryFormField({
    super.key,
    required BuildContext context,
    required FormFieldSetter<Category> super.onSaved,
    required Category super.initialValue,
    required List<Category> categories,
  }) : super(
          builder: (state) {
            final theme = Theme.of(context);
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.secondary),
              ),
              child: ListTile(
                title: Text(state.value?.title ?? ''),
                subtitle: Text(
                  'Available Budget: ${state.value?.availableBudget.currencyFormat}',
                ),
                trailing: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return SimpleDialog(
                        contentPadding: const EdgeInsets.all(24),
                        insetPadding: EdgeInsets.zero,
                        children: [
                          ...List.generate(categories.length, (i) {
                            final category = categories[i];
                            return ListTile(
                              onTap: () {
                                state.didChange(category);
                                Navigator.of(context).pop();
                              },
                              leading: Center(
                                widthFactor: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: category.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      category.icon,
                                      color: category.color,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                category.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Radio<Category>(
                                fillColor: MaterialStateProperty.all(
                                  theme.colorScheme.secondary,
                                ),
                                value: category,
                                groupValue: state.value,
                                onChanged: (v) {
                                  state.didChange(v);
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          }),
                          // ListTile(
                          //   title: const Text('Add Category'),
                          //   leading: Icon(
                          //     Icons.add,
                          //     color: theme.colorScheme.secondary,
                          //   ),
                          // )
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        );
}
