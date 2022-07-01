import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../budget/budget.dart';

const List<ChartData> chartData = [
  ChartData('MON', 35),
  ChartData('TUE', 23),
  ChartData('WED', 34),
  ChartData('THU', 25),
  ChartData('FRI', 40),
  ChartData('SAT', 20),
  ChartData('SUN', 42),
];

class StatChart extends StatelessWidget {
  const StatChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: '01 - 07 Jan, 2022'),
      series: <ChartSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          // Width of the columns
          width: 0.8,
          // Spacing between the columns
          spacing: 0.2,
          color: Colors.amber,
          dataLabelMapper: (data, _) => '${data.y.toInt()}K',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        )
      ],
    );
  }
}
