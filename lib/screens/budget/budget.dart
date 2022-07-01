import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/category.dart';
import '../../shared/widgets/category_list_tile.dart';
import '../../shared/widgets/kspacer.dart';

class ChartData {
  const ChartData(this.x, this.y, [this.color = Colors.black]);
  final String x;
  final double y;
  final Color color;
}

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({Key? key}) : super(key: key);
  static final appBar = AppBar(
    title: const Text('Budget'),
  );

  @override
  Widget build(BuildContext context) {
    const List<ChartData> chartData = [
      ChartData('David', 25, Color.fromRGBO(9, 0, 136, 1)),
      ChartData('Steve', 38, Color.fromRGBO(147, 0, 119, 1)),
      ChartData('Jack', 34, Color.fromRGBO(228, 0, 124, 1)),
      ChartData('Others', 52, Color.fromRGBO(255, 189, 57, 1))
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SfCircularChart(
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: chartData,
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (datum, index) => datum.x,
                    yValueMapper: (datum, index) => datum.y,
                    dataLabelMapper: (data, _) => data.y.toString(),
                    innerRadius: '60%',
                    radius: '80%',
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                    ),
                  )
                ],
              ),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Rs 20,000',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
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
                  children: const [
                    Text(
                      'Total Budget',
                      textScaleFactor: 0.9,
                    ),
                    Text(
                      'Rs 125,000',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Column(
                  children: const [
                    Text(
                      'Total Spent',
                      textScaleFactor: 0.9,
                    ),
                    Text(
                      'Rs 95,000',
                      style: TextStyle(fontWeight: FontWeight.w500),
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
            child: const Text('Set Monthly Budget'),
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
                    value: Random().nextDouble(),
                    color: category.color,
                  ),
                  trailing: const Text(
                    'Rs 0',
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
