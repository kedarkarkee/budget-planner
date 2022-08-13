import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/category.dart';
import '../../providers/category_provider.dart';
import '../../shared/widgets/category_list_tile.dart';
import '../../shared/widgets/kspacer.dart';
import '../../utils/extensions.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({Key? key}) : super(key: key);
  static final appBar = AppBar(
    title: const Text('Budget'),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final totalBudget = ref.watch(
      categoriesProvider.notifier.select((value) => value.totalBudget),
    );
    final totalSpent = ref.watch(
      categoriesProvider.notifier.select((value) => value.totalSpent),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.top,
                  isResponsive: true,
                  offset: const Offset(0, 0),
                ),
                series: <CircularSeries>[
                  DoughnutSeries<Category, String>(
                    dataSource: categories,
                    pointColorMapper: (data, _) => data.color,
                    xValueMapper: (datum, index) => datum.title,
                    yValueMapper: (datum, index) => datum.budget,
                    innerRadius: '60%',
                    radius: '80%',
                  )
                ],
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: (totalBudget - totalSpent).currencyFormat,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: const [
                    TextSpan(
                      text: '\nleft',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Column(
                  children: [
                    const Text(
                      'Total Budget',
                      textScaleFactor: 0.9,
                    ),
                    Text(
                      totalBudget.currencyFormat,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Column(
                  children: [
                    const Text(
                      'Total Spent',
                      textScaleFactor: 0.9,
                    ),
                    Text(
                      totalSpent.currencyFormat,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          kSpacer,
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/set-budget');
            },
            child: const Text('Edit Monthly Budget'),
          ),
          kSpacer,
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              padding: const EdgeInsets.only(bottom: 24),
              itemBuilder: (c, i) {
                final category = categories[i];
                return CategoryListTile(
                  category: category,
                  subtitle: LinearProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    value: category.budget == 0
                        ? 0
                        : category.spent / category.budget,
                    color: category.color,
                  ),
                  trailing: Text(
                    category.budget.currencyFormat,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
