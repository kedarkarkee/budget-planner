import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/transaction.dart';
import '../../providers/transactions_provider.dart';
import '../../shared/widgets/category_list_tile.dart';

class TransactionsLists extends StatefulWidget {
  const TransactionsLists({super.key});

  @override
  State<TransactionsLists> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsLists>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.black,
          labelColor: [
            Theme.of(context).colorScheme.secondary,
            Colors.green,
            Colors.red
          ][_tabController.index],
          tabs: const [
            Tab(
              text: 'All',
            ),
            Tab(
              text: 'Income',
            ),
            Tab(
              text: 'Expenses',
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(3, (index) {
              return TransactionList(index: index);
            }),
          ),
        ),
      ],
    );
  }
}

class TransactionList extends ConsumerWidget {
  const TransactionList({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    var reqTransactions = [...transactions];
    if (index == 1) {
      reqTransactions = transactions
          .where((e) => e.transactionType == TransactionType.income)
          .toList();
    } else if (index == 2) {
      reqTransactions = transactions
          .where((e) => e.transactionType == TransactionType.expense)
          .toList();
    }
    if (reqTransactions.isEmpty) {
      return const Center(
        child: Text('No Transactions'),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: reqTransactions.length,
      padding: const EdgeInsets.only(bottom: 24),
      itemBuilder: (c, i) {
        final t = reqTransactions[i];
        return CategoryListTile(
          category: t.category,
          title: t.remarks,
          subtitle: Text(
            t.subtitle,
          ),
          trailing: Text(
            t.amountFormatted,
            style: TextStyle(
              color: t.transactionType == TransactionType.income
                  ? Colors.green
                  : Colors.red,
            ),
          ),
          isThreeLine: true,
          onLongPress: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Delete Transaction'),
                  content: ListTile(
                    title: Text(t.remarks),
                    subtitle: Text(t.category.title),
                    trailing: Text(
                      t.amountFormatted,
                      style: TextStyle(
                        color: t.transactionType == TransactionType.expense
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(transactionsProvider.notifier)
                            .deleteTransaction(t);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
