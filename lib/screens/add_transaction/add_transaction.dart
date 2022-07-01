import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../shared/widgets/kspacer.dart';
import '../../shared/widgets/tab_card.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();
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
                // TODO: Use Custom Form Field
                Row(
                  children: [
                    ...List.generate(2, (i) {
                      final isActive = i == 0;
                      return Expanded(
                        child: TabCard(
                          isActive: isActive,
                          title: i == 0 ? 'Expense' : 'Income',
                        ),
                      );
                    })
                  ],
                ),
                kSpacer,
                const Text('What did you spend on ?'),
                kSpacer,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.secondary),
                  ),
                  child: ListTile(
                    title: const Text('Food and Drinks'),
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
                                  leading: Center(
                                    widthFactor: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: category.color.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                  trailing: Radio<String>(
                                    fillColor: MaterialStateProperty.all(
                                      theme.colorScheme.secondary,
                                    ),
                                    value: category.title,
                                    groupValue: categories.first.title,
                                    onChanged: (v) {},
                                  ),
                                );
                              }),
                              ListTile(
                                title: const Text('Add Category'),
                                leading: Icon(
                                  Icons.add,
                                  color: theme.colorScheme.secondary,
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),

                kSpacer,
                const Text('How much did you spend ?'),
                kSpacer,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.secondary),
                  ),
                  child: Row(
                    children: [
                      Container(
                        color: theme.colorScheme.secondary,
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        child: const Text(
                          '\$',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textScaleFactor: 1.5,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: '1,000',
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                kSpacer,
                const Text('When did you spend ?'),
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
                    hintText: '01/09/2022',
                  ),
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      initialDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                  },
                ),
                kSpacer,
                ElevatedButton(onPressed: () {}, child: const Text('Add')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
