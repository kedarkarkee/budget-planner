import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../models/transaction.dart';
import '../../utils/extensions.dart';

class TRLineData {
  final DateTime date;
  num value = 0;

  TRLineData(this.date, this.value);

  void addAmount(num a) {
    value += a;
  }
}

List<TRLineData> tRLineFromTransactions(
  List<Transaction> ts,
  TransactionType transactionType,
) {
  final dt = <TRLineData>[];
  for (final t in ts) {
    if (t.transactionType != transactionType) {
      continue;
    }
    var exdt = dt.firstWhereOrNull((e) => e.date.isSameDayAs(t.date));
    if (exdt == null) {
      exdt = TRLineData(t.date, t.amount);
      dt.add(exdt);
    } else {
      exdt.addAmount(t.amount);
    }
  }
  return dt;
}

List<num> getMinMaxFromTR(List<TRLineData> tr) {
  num minV = double.infinity;
  num maxV = 0;
  for (final t in tr) {
    minV = min(minV, t.value);
    maxV = max(maxV, t.value);
  }
  return [minV, maxV];
}

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.transactionType,
    required this.transactions,
    required this.dateRange,
  });
  final List<Transaction> transactions;
  final TransactionType transactionType;
  final PickerDateRange dateRange;

  @override
  Widget build(BuildContext context) {
    final chartData = tRLineFromTransactions(transactions, transactionType);
    final minMax = getMinMaxFromTR(chartData);
    return SfCartesianChart(
      title: ChartTitle(
        text: '${toBeginningOfSentenceCase(transactionType.name)} over Time',
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        markerSettings: const TrackballMarkerSettings(
          borderWidth: 4,
          height: 10,
          width: 10,
          markerVisibility: TrackballVisibilityMode.visible,
        ),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      ),
      primaryXAxis: DateTimeAxis(
        minimum: dateRange.startDate,
        maximum: dateRange.endDate?.add(const Duration(days: 1)),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        intervalType: DateTimeIntervalType.days,
        dateFormat: DateFormat('MMM d'),
      ),
      primaryYAxis: NumericAxis(
        minimum: minMax[0].toDouble() - 100,
        maximum: minMax[1].toDouble() + 100,
      ),
      series: <ChartSeries>[
        FastLineSeries<TRLineData, DateTime>(
          dataSource: chartData,
          xValueMapper: (s, _) => s.date,
          yValueMapper: (s, _) => s.value,
          enableTooltip: true,
          color: Theme.of(context).colorScheme.primary,
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 7,
            width: 7,
          ),
        )
      ],
    );
  }
}
