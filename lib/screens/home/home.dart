import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/transactions_provider.dart';
import 'transactions_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Recent Transacations',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          content: const Text('Random Transactions'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(transactionsProvider.notifier)
                                    .deleteAllRecords();
                                Navigator.of(context).pop();
                              },
                              child: const Text('DELETE'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(transactionsProvider.notifier)
                                    .addRandomTransactions();
                                Navigator.of(context).pop();
                              },
                              child: const Text('ADD'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.refresh_outlined),
                ),
              ],
            ),
            // CarouselSlider(
            //   items: List.generate(
            //     3,
            //     (index) => SizedBox(
            //       width: double.infinity,
            //       child: Card(
            //         elevation: 0,
            //         color: Colors.grey[200],
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //         ),
            //       ),
            //     ),
            //   ),
            //   options: CarouselOptions(
            //     enableInfiniteScroll: false,
            //     scrollPhysics: const BouncingScrollPhysics(),
            //     enlargeCenterPage: true,
            //   ),
            // ),
            const Expanded(child: TransactionsLists())
          ],
        ),
      ),
    );
  }
}
