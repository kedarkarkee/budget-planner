import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../shared/widgets/category_list_tile.dart';
import '../../shared/widgets/kspacer.dart';

class SetBudget extends StatelessWidget {
  const SetBudget({Key? key, this.isEditing = false}) : super(key: key);

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
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
                    final category = categories[i % 4];
                    return CategoryListTile(
                      category: category,
                      trailing: InkWell(
                        onTap: () {
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
                                        hintText: '1000',
                                        prefixText: 'Rs\t',
                                      ),
                                      keyboardType: TextInputType.number,
                                      readOnly: true,
                                      onTap: () {},
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
                          child: const Text('Rs 20000'),
                        ),
                      ),
                    );
                  },
                  itemCount: categories.length,
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  showDialog(
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
                              ),
                              readOnly: true,
                              onTap: () {},
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
                },
                child: const Text('+ Add new category'),
              ),
              kSpacer,
              ElevatedButton(
                onPressed: () {},
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
