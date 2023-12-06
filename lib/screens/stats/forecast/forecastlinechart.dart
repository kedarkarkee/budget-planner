import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../models/transaction.dart';
import '../line_chart.dart';
import 'controller.dart';

List<TRLineData> combinePastandForecast(
  List<TRLineData> past,
  List<TimeSeries> future,
) {
  final pastCopy = [...past];
  for (final f in future) {
    pastCopy.add(TRLineData(f.date, f.value));
  }
  return pastCopy;
}

class ForecastLineChart extends StatelessWidget {
  const ForecastLineChart({
    super.key,
    required this.transactionType,
    required this.transactions,
    required this.dateRange,
    required this.forecaseData,
  });
  final List<Transaction> transactions;
  final TransactionType transactionType;
  final PickerDateRange dateRange;
  final List<TimeSeries> forecaseData;

  @override
  Widget build(BuildContext context) {
    final pastTR = tRLineFromTransactions(transactions, transactionType);
    final chartData = combinePastandForecast(pastTR, forecaseData);
    final minMax = getMinMaxFromTR(chartData);
    final lastDate = pastTR.last.date;
    return SfCartesianChart(
      title: ChartTitle(
        text: '${toBeginningOfSentenceCase(transactionType.name)}s over Time',
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
        maximum: dateRange.endDate?.add(const Duration(days: 8)),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        intervalType: DateTimeIntervalType.days,
        dateFormat: DateFormat('MMM d'),
      ),
      primaryYAxis: NumericAxis(
        minimum: minMax[0].toDouble() - 100,
        maximum: minMax[1].toDouble() + 100,
      ),
      series: <ChartSeries>[
        LineSeries<TRLineData, DateTime>(
          dataSource: chartData,
          xValueMapper: (s, _) => s.date,
          yValueMapper: (s, _) => s.value,
          pointColorMapper: (s, _) => s.date.isAfter(lastDate)
              ? Colors.purple
              : Theme.of(context).colorScheme.primary,
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
