import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../models/transaction.dart';
import '../../../providers/transactions_provider.dart';
import '../line_chart.dart';
import '../stat_chart.dart';
import 'controller.dart';
import 'forecastlinechart.dart';
import 'futurestats.dart';

final tabProvider = StateNotifierProvider<CurrentTabIndex, int>(
  (ref) {
    return CurrentTabIndex();
  },
);

class CurrentTabIndex extends StateNotifier<int> {
  CurrentTabIndex() : super(0);

  void changeIndex(int index) {
    state = index;
  }
}

final dateRangeProvider =
    StateNotifierProvider<CurrentDateRange, PickerDateRange>(
  (ref) {
    return CurrentDateRange();
  },
);

class CurrentDateRange extends StateNotifier<PickerDateRange> {
  CurrentDateRange()
      : super(
          PickerDateRange(
            DateTime.now().subtract(const Duration(days: 30)),
            DateTime.now(),
          ),
        );

  void changeDateRange(PickerDateRange d) {
    state = d;
  }
}

class ForecastsScreen extends ConsumerWidget {
  const ForecastsScreen({super.key});
  static final appBar = AppBar(
    title: const Text('Stats'),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(tabProvider);
    final transactions = ref.watch(transactionsProvider);
    final currentDateRange = ref.watch(dateRangeProvider);
    final filteredTx = transactions
        .where(
          (e) =>
              e.date.isAfter(currentDateRange.startDate!) &&
              e.date.isBefore(
                currentDateRange.endDate!.add(const Duration(days: 1)),
              ),
        )
        .toList();
    if (filteredTx.length < 28) {
      return const Center(
        child: Text('At least a month record is needed for prediction'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder<ResponseModel?>(
        future: requestPredictor(
          tRLineFromTransactions(filteredTx, TransactionType.expense),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final forecastData = snapshot.data!.predictions;
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: StatChart(
                    transactions: transactions,
                    transactionType: currentTab == 0
                        ? TransactionType.expense
                        : TransactionType.income,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: FutureStatChart(
                    transactions: forecastData,
                    transactionType: currentTab == 0
                        ? TransactionType.expense
                        : TransactionType.income,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      const Text(
                        'Actual',
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Container(
                        color: Colors.purple,
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      const Text(
                        'Predicted',
                        // style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const SizedBox(
                //       width: 24.0,
                //     ),
                //     Expanded(
                //       child: Text(
                //         '${currentDateRange.startDate?.dayMonth} - ${currentDateRange.endDate?.dayMonthYear}',
                //         textAlign: TextAlign.center,
                //         textScaleFactor: 1.2,
                //       ),
                //     ),
                //     IconButton(
                //       onPressed: () async {
                //         final dateRange = await showDialog<PickerDateRange>(
                //           context: context,
                //           builder: (ctx) {
                //             return AlertDialog(
                //               content: SizedBox(
                //                 width: MediaQuery.of(ctx).size.width,
                //                 height: MediaQuery.of(ctx).size.width,
                //                 child: SfDateRangePicker(
                //                   selectionMode:
                //                       DateRangePickerSelectionMode.range,
                //                   maxDate: DateTime.now(),
                //                   showActionButtons: true,
                //                   onCancel: () {
                //                     Navigator.of(context).pop();
                //                   },
                //                   onSubmit: (d) {
                //                     Navigator.of(context).pop(d);
                //                   },
                //                 ),
                //               ),
                //             );
                //           },
                //         );
                //         if (dateRange != null &&
                //             dateRange.startDate != null &&
                //             dateRange.endDate != null) {
                //           ref
                //               .read(dateRangeProvider.notifier)
                //               .changeDateRange(dateRange);
                //         }
                //       },
                //       icon: const Icon(Icons.date_range_outlined),
                //     ),
                //   ],
                // ),
                if (filteredTx.isEmpty) const Text('No Data to Display'),
                if (filteredTx.isNotEmpty)
                  ForecastLineChart(
                    transactionType: currentTab == 0
                        ? TransactionType.expense
                        : TransactionType.income,
                    transactions: filteredTx,
                    forecaseData: forecastData,
                    dateRange: currentDateRange,
                  ),
                // if (filteredTx.isNotEmpty)
                //   PieChart(
                //     transactions: filteredTx,
                //     transactionType: currentTab == 0
                //         ? TransactionType.expense
                //         : TransactionType.income,
                //   )
                const SizedBox(
                  height: 16,
                ),
                // ListTile(
                //   title: const Text('Mean Squared Error'),
                //   trailing: Text(snapshot.data!.mse.toStringAsFixed(2)),
                // ),
                // ListTile(
                //   title: const Text('Sum Squared Error'),
                //   trailing: Text(snapshot.data!.sse.toStringAsFixed(2)),
                // ),
                // ListTile(
                //   title: const Text('Mean Percentage Error'),
                //   trailing: Text(snapshot.data!.mpe.toStringAsFixed(4)),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
