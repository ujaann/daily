import 'package:calendar_view/calendar_view.dart';
import 'package:daily/entity/expense.dart';
import 'package:daily/features/expense/data/expense_repo.dart';
import 'package:daily/features/graphs/bar_chart.dart';
import 'package:daily/features/graphs/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GraphsScreen extends ConsumerWidget {
  const GraphsScreen({super.key});

  Map<WeekDays, (double, double)> getWeeklyData(WidgetRef ref) {
    final today = DateTime.now();

    final data = ref
        .read(expenseRepoProvider)
        .getWeeklyExpenses(today.firstDayOfWeek(), today.lastDayOfWeek());
    return {
      for (final entry in data.entries)
        entry.key: (
          entry.value
              .where((e) => e.type == ExpenseType.expense)
              .fold(0.0, (sum, e) => sum + e.amount),
          entry.value
              .where((e) => e.type == ExpenseType.income)
              .fold(0.0, (sum, e) => sum + e.amount)
        )
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyExpenses = getWeeklyData(ref);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          // ToggleButtons(
          //   isSelected: [true, false],
          //   onPressed: (int index) {
          //     // Implement state management to handle toggle selection
          //   },
          //   children: const [
          //     Text('Expense'),
          //     Text('Income'),
          //   ],
          // ),
          // const SizedBox(height: 12),
          BarChartSample2(
            sunday: weeklyExpenses[WeekDays.sunday] ?? (0.0, 0.0),
            monday: weeklyExpenses[WeekDays.monday] ?? (0.0, 0.0),
            tuesday: weeklyExpenses[WeekDays.tuesday] ?? (0.0, 0.0),
            wednesday: weeklyExpenses[WeekDays.wednesday] ?? (0.0, 0.0),
            thursday: weeklyExpenses[WeekDays.thursday] ?? (0.0, 0.0),
            friday: weeklyExpenses[WeekDays.friday] ?? (0.0, 0.0),
            saturday: weeklyExpenses[WeekDays.saturday] ?? (0.0, 0.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              spacing: 24,
              children: [
                Indicator(
                    color: Colors.red, text: "Expenses ", isSquare: false),
                Indicator(
                    color: Colors.green, text: "Incomes ", isSquare: false),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text("Monthly expenses", style: TextStyle(fontSize: 22)),
          PieChartSample2(),
        ],
      ),
    );
  }
}
