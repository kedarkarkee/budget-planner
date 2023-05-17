import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../budget/budget.dart';
import '../home/home.dart';
import '../stats/stats.dart';

final bottomNavProvider = StateNotifierProvider<CurrentBottomNavIndex, int>(
  (ref) {
    return CurrentBottomNavIndex();
  },
);

class CurrentBottomNavIndex extends StateNotifier<int> {
  CurrentBottomNavIndex() : super(0);

  void changeIndex(int index) {
    state = index;
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Widget _getCurrentWidget(int index) {
    if (index == 0) {
      return const HomeScreen();
    } else if (index == 1) {
      return const BudgetScreen();
    } else if (index == 2) {
      return const StatsScreen();
    } else {
      return const SizedBox.shrink();
    }
  }

  PreferredSizeWidget? _getCurrentAppbar(int index) {
    if (index == 1) {
      return BudgetScreen.appBar;
    } else if (index == 2) {
      return StatsScreen.appBar;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      appBar: _getCurrentAppbar(currentIndex),
      body: _getCurrentWidget(currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) {
          ref.read(bottomNavProvider.notifier).changeIndex(i);
        },
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.wallet),
            title: const Text('Budget'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.timeline),
            title: const Text('Stats'),
          ),
          // SalomonBottomBarItem(
          //   icon: const Icon(Icons.person),
          //   title: const Text('Profile'),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-transaction');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
