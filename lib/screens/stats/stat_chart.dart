import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/transaction.dart';
import '../../utils/extensions.dart';

class TRData {
  final int weekday;
  num amount = 0;

  TRData(this.weekday, this.amount);

  void addAmount(num a) {
    amount += a;
  }
}

List<TRData> fromTransactions(
  List<Transaction> transactions,
  TransactionType transactionType,
) {
  final todaysWeekDay = DateTime.now().weekday - 1;
  final ddt = List.generate(7, (i) => TRData(i + 1, 0));
  final dt = ddt.sublist(todaysWeekDay)..addAll(ddt.sublist(0, todaysWeekDay));
  for (final t in transactions) {
    if (t.transactionType != transactionType) {
      continue;
    }
    final existingDt = dt.firstWhere(
      (e) => e.weekday == t.date.weekday,
      orElse: () {
        final d = TRData(t.date.weekday, 0);
        dt.add(d);
        return d;
      },
    );
    existingDt.addAmount(t.amount);
  }
  return dt.reversed.toList();
}

class StatChart extends StatelessWidget {
  const StatChart({
    Key? key,
    required this.transactionType,
    required this.transactions,
  }) : super(key: key);
  final List<Transaction> transactions;
  final TransactionType transactionType;

  @override
  Widget build(BuildContext context) {
    final chartData = fromTransactions(transactions, transactionType);
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
        text: 'Last Week ${toBeginningOfSentenceCase(transactionType.name)}',
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
          color: Colors.amber,
          dataLabelMapper: (data, _) => '${data.amount}',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        )
      ],
    );
  }
}
