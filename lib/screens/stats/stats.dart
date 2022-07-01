import 'package:flutter/material.dart';

import '../../shared/widgets/tab_card.dart';
import 'stat_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);
  static final appBar = AppBar(
    title: const Text('Stats'),
  );
  final hasStats = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              ...List.generate(2, (i) {
                final title = i == 0 ? 'Expenses' : 'Income';
                return Expanded(
                  child: TabCard(
                    isActive: i == 0,
                    title: title,
                    subtitle: 'Rs 34000',
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
              child: const StatChart(),
            )
        ],
      ),
    );
  }
}
