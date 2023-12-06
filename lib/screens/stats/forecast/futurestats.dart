import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/transaction.dart';
import '../../../utils/extensions.dart';
import '../stat_chart.dart';
import 'controller.dart';

class FutureStatChart extends StatelessWidget {
  const FutureStatChart({
    super.key,
    required this.transactionType,
    required this.transactions,
  });
  final List<TimeSeries> transactions;
  final TransactionType transactionType;

  @override
  Widget build(BuildContext context) {
    final chartData = transactions.map((e) => e.trData).toList();
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
      title: ChartTitle(
        text:
            'Predicted Next 7 Days ${toBeginningOfSentenceCase(transactionType.name)}s',
      ),
      series: <ChartSeries<TRData, String>>[
        ColumnSeries<TRData, String>(
          dataSource: chartData,
          xValueMapper: (data, _) => data.weekday.weekDayString,
          yValueMapper: (data, _) => data.amount,
          // Width of the columns
          width: 0.8,
          // Spacing between the columns
          spacing: 0.2,
          color: Colors.purple,
          dataLabelMapper: (data, _) => '${data.amount}',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        )
      ],
    );
  }
}
