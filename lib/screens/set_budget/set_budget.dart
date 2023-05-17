import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/category.dart';
import '../../providers/category_provider.dart';
import '../../shared/widgets/category_list_tile.dart';
import '../../shared/widgets/kspacer.dart';
import '../../utils/extensions.dart';

class SetBudget extends ConsumerWidget {
  const SetBudget({super.key, this.isEditing = false});

  final bool isEditing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Budget' : 'Set Budget')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              kSpacer,
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    final category = categories[i];
                    return CategoryListTile(
                      category: category,
                      trailing: InkWell(
                        onTap: () {
                          num budget = category.budget;
                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return SimpleDialog(
                                title: Text(
                                  category.title,
                                  textAlign: TextAlign.center,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TextField(
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ),
                                        hintText: category.budget.toString(),
                                        prefixText: 'Rs\t',
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (v) {
                                        budget = num.tryParse(v) ?? budget;
                                      },
                                    ),
                                  ),
                                  TextButton(
                                    child: const Text('Done'),
                                    onPressed: () {
                                      category.budget = budget;
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                                // children: const [],
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: theme.colorScheme.secondary),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: Text(category.budget.currencyFormat),
                        ),
                      ),
                    );
                  },
                  itemCount: categories.length,
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  String name = '';
                  await showDialog(
                    context: context,
                    builder: (ctx) {
                      return SimpleDialog(
                        title: const Text(
                          'Add Category',
                          textAlign: TextAlign.center,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              autofocus: true,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                hintText: 'Category Name',
                              ),
                              onChanged: (s) {
                                name = s;
                              },
                            ),
                          ),
                          TextButton(
                            child: const Text('Done'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                        // children: const [],
                      );
                    },
                  );
                  final c = Category(name, Icons.category, Colors.indigo);
                  ref.read(categoriesProvider.notifier).addCategory(c);
                },
                child: const Text('+ Add new category'),
              ),
              kSpacer,
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
