import 'dart:math';

import 'package:calendar_view/calendar_view.dart';
import 'package:daily/entity/expense.dart';
import 'package:daily/features/expense/data/expense_repo.dart';
import 'package:daily/features/graphs/bar_chart.dart';
import 'package:daily/features/graphs/pie_chart.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chartReadyProvider = StateProvider.autoDispose<bool>((ref) => false);

// Provider for weekly data
final weeklyDataProvider = Provider<Map<WeekDays, (double, double)>>((ref) {
  final today = DateTime.now();
  final repo = ref.watch(expenseRepoProvider);

  final data =
      repo.getWeeklyExpenses(today.firstDayOfWeek(), today.lastDayOfWeek());

  return {
    for (final entry in data.entries)
      entry.key: (
        entry.value
            .where((e) => e.type == ExpenseType.expense)
            .fold(0.0, (sum, e) => sum + e.amount),
        entry.value
            .where((e) => e.type == ExpenseType.income)
            .fold(0.0, (sum, e) => sum + e.amount),
      )
  };
});

// Provider for current month data (expense & income maps)
final currentMonthDataProvider =
    Provider<(Map<String, double>, Map<String, double>)>((ref) {
  final repo = ref.watch(expenseRepoProvider);
  final data = repo.getCurrentMonthExpenses();

  final expenseMap = <String, double>{};
  final incomeMap = <String, double>{};

  for (final item in data) {
    if (item.type == ExpenseType.expense) {
      expenseMap[item.category] =
          (expenseMap[item.category] ?? 0) + item.amount;
    } else if (item.type == ExpenseType.income) {
      incomeMap[item.category] = (incomeMap[item.category] ?? 0) + item.amount;
    }
  }

  return (expenseMap, incomeMap);
});

class GraphsScreen extends ConsumerStatefulWidget {
  const GraphsScreen({super.key});

  @override
  ConsumerState<GraphsScreen> createState() => _GraphsScreenState();
}

class _GraphsScreenState extends ConsumerState<GraphsScreen> {
  @override
  void initState() {
    super.initState();

    // Let Flutter draw the loading UI first, then set chartReady = true
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        ref.read(chartReadyProvider.notifier).state = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final chartReady = ref.watch(chartReadyProvider);

    return chartReady
        ? const _GraphsContent()
        : const Center(
            child: Text(
            "Loading...",
            style: FontsDaily.bigHeadline,
          ));
  }
}

class _GraphsContent extends ConsumerWidget {
  const _GraphsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyExpenses = ref.read(weeklyDataProvider);
    final currentMonthExpenses = ref.read(currentMonthDataProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          RepaintBoundary(
            child: BarChartSample2(
              sunday: weeklyExpenses[WeekDays.sunday] ?? (0.0, 0.0),
              monday: weeklyExpenses[WeekDays.monday] ?? (0.0, 0.0),
              tuesday: weeklyExpenses[WeekDays.tuesday] ?? (0.0, 0.0),
              wednesday: weeklyExpenses[WeekDays.wednesday] ?? (0.0, 0.0),
              thursday: weeklyExpenses[WeekDays.thursday] ?? (0.0, 0.0),
              friday: weeklyExpenses[WeekDays.friday] ?? (0.0, 0.0),
              saturday: weeklyExpenses[WeekDays.saturday] ?? (0.0, 0.0),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Monthly expenses & income",
            style: FontsDaily.bigTitle,
          ),
          SizedBox(
            height: 260 +
                18 *
                    max(currentMonthExpenses.$1.length.toDouble(),
                        currentMonthExpenses.$2.length.toDouble()),
            child: PageView(
              children: [
                RepaintBoundary(
                  child: currentMonthExpenses.$1.isEmpty
                      ? Center(
                          child: Text("No entries", style: FontsDaily.bigTitle))
                      : PieChartSample2(dataMap: currentMonthExpenses.$1),
                ),
                RepaintBoundary(
                  child: currentMonthExpenses.$2.isEmpty
                      ? Center(
                          child: Text("No entries", style: FontsDaily.bigTitle))
                      : PieChartSample2(dataMap: currentMonthExpenses.$2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
