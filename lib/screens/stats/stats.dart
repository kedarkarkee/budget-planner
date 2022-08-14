import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../models/transaction.dart';
import '../../providers/category_provider.dart';
import '../../providers/transactions_provider.dart';
import '../../shared/widgets/tab_card.dart';
import '../../utils/extensions.dart';
import 'line_chart.dart';
import 'pie_chart.dart';
import 'stat_chart.dart';

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

class StatsScreen extends ConsumerWidget {
  const StatsScreen({Key? key}) : super(key: key);
  static final appBar = AppBar(
    title: const Text('Stats'),
  );
  final hasStats = true;

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
    final totalBudget = ref.watch(
      categoriesProvider.notifier.select((value) => value.totalBudget),
    );
    final totalSpent = ref.watch(
      categoriesProvider.notifier.select((value) => value.totalSpent),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                ...List.generate(TransactionType.values.length, (i) {
                  final t = TransactionType.values.reversed.elementAt(i);
                  return Expanded(
                    child: TabCard(
                      isActive: i == currentTab,
                      title: toBeginningOfSentenceCase(t.name) ?? t.name,
                      subtitle: i == 0
                          ? totalSpent.currencyFormat
                          : totalBudget.currencyFormat,
                      onTap: () =>
                          {ref.read(tabProvider.notifier).changeIndex(i)},
                    ),
                  );
                }),
              ],
            ),
            if (!hasStats)
              const Expanded(child: Center(child: Text('No Stats Available')))
            else
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
                child: StatChart(
                  transactions: transactions,
                  transactionType: currentTab == 0
                      ? TransactionType.expense
                      : TransactionType.income,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 24.0,
                ),
                Expanded(
                  child: Text(
                    '${currentDateRange.startDate?.dayMonth} - ${currentDateRange.endDate?.dayMonthYear}',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.2,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final dateRange = await showDialog<PickerDateRange>(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          content: SizedBox(
                            width: MediaQuery.of(ctx).size.width,
                            height: MediaQuery.of(ctx).size.width,
                            child: SfDateRangePicker(
                              selectionMode: DateRangePickerSelectionMode.range,
                              maxDate: DateTime.now(),
                              showActionButtons: true,
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                              onSubmit: (d) {
                                Navigator.of(context).pop(d);
                              },
                            ),
                          ),
                        );
                      },
                    );
                    if (dateRange != null &&
                        dateRange.startDate != null &&
                        dateRange.endDate != null) {
                      ref
                          .read(dateRangeProvider.notifier)
                          .changeDateRange(dateRange);
                    }
                  },
                  icon: const Icon(Icons.date_range_outlined),
                ),
              ],
            ),
            if (filteredTx.isEmpty) const Text('No Data to Display'),
            if (filteredTx.isNotEmpty)
              LineChart(
                transactionType: currentTab == 0
                    ? TransactionType.expense
                    : TransactionType.income,
                transactions: filteredTx,
                dateRange: currentDateRange,
              ),
            if (filteredTx.isNotEmpty)
              PieChart(
                transactions: filteredTx,
                transactionType: currentTab == 0
                    ? TransactionType.expense
                    : TransactionType.income,
              )
          ],
        ),
      ),
    );
  }
}
