import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../shared/widgets/category_list_tile.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({Key? key}) : super(key: key);

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList>
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
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length,
                padding: const EdgeInsets.only(bottom: 24),
                itemBuilder: (c, i) {
                  final category = categories[i];
                  return CategoryListTile(
                    category: category,
                    subtitle: const Text('Remarks\n2019/09/21'),
                    trailing: Text(
                      'Rs 5,600',
                      style: TextStyle(
                        color: [
                          Colors.green,
                          Colors.red
                        ][index == 0 ? Random().nextInt(2) : index - 1],
                      ),
                    ),
                    isThreeLine: true,
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
