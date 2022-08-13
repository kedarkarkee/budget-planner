import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/transaction.dart';
import '../../utils/extensions.dart';

class TRPieData {
  final String category;
  num amount = 0;
  final Color color;

  void addAmount(num a) {
    amount += a;
  }

  TRPieData(this.category, this.amount, this.color);
}

List<TRPieData> tRPiefromTransaction(
  List<Transaction> ts,
  TransactionType transactionType,
) {
  final dt = <TRPieData>[];
  for (final t in ts) {
    if (t.transactionType != transactionType) {
      continue;
    }
    var edt =
        dt.firstWhereOrNull((element) => element.category == t.category.title);
    if (edt == null) {
      edt = TRPieData(t.category.title, t.amount, t.category.color);
      dt.add(edt);
    } else {
      edt.addAmount(t.amount);
    }
  }
  return dt;
}

class PieChart extends StatelessWidget {
  const PieChart({
    Key? key,
    required this.transactionType,
    required this.transactions,
  }) : super(key: key);
  final List<Transaction> transactions;
  final TransactionType transactionType;

  @override
  Widget build(BuildContext context) {
    final chartData = tRPiefromTransaction(transactions, transactionType);
    return SfCircularChart(
      title: ChartTitle(text: 'Category Distribution'),
      series: <CircularSeries<TRPieData, String>>[
        PieSeries<TRPieData, String>(
          dataSource: chartData,
          xValueMapper: (data, _) => data.category,
          yValueMapper: (data, _) => data.amount,
          radius: '100%',
          pointColorMapper: (datum, index) => datum.color,
          dataLabelMapper: (data, _) => data.category,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            overflowMode: OverflowMode.shift,
          ),
        )
      ],
    );
  }
}
