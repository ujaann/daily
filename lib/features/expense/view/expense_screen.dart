import 'package:daily/entity/expense.dart';
import 'package:daily/features/expense/data/expense_repo.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/dependencies.dart';
import 'package:daily/util/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_screen.g.dart';

final _selectedMonthProvider = StateProvider.autoDispose<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

@riverpod
List<ExpenseEntity> userExpenses(Ref ref, String userId) {
  final repo = ref.watch(expenseRepoProvider);
  return repo.getExpenses(
    userId,
  );
}

class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = ref.watch(expenseRepoProvider).box;

    return ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, box, _) {
          final expenses = box.values.where((e) => e.userId == "Ujan");
          return Column(
            children: [
              ExpenseInfo(
                expenses: expenses.toList(),
              ),
              if (expenses.isEmpty) ...{
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sticky_note_2,
                      size: 40,
                    ),
                    Text('No expenses'),
                  ],
                ))
              } else
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses.elementAt(index);

                      final icon = switch (expense.type) {
                        ExpenseType.expense => expenseIconMap[expense.category],
                        ExpenseType.income => incomeIconMap[expense.category],
                      };

                      return ListTile(
                        leading: Icon(icon),
                        title: Text(expense.note),
                        trailing: Text(
                          '${expense.type == ExpenseType.expense ? '-' : ''}${expense.amount}',
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        });
  }
}

class ExpenseInfo extends ConsumerWidget {
  final List<ExpenseEntity> expenses;

  const ExpenseInfo({super.key, required this.expenses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(_selectedMonthProvider);

    final double monthlyIncome = expenses
        .where((e) =>
            e.type == ExpenseType.income &&
            e.date.year == now.year &&
            e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);

    final double monthlyExpense = expenses
        .where((e) =>
            e.type == ExpenseType.expense &&
            e.date.year == now.year &&
            e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);

    final double monthlyBalance = monthlyIncome - monthlyExpense;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  now.year.toString(),
                  style: FontsDaily.titleSubText,
                ),
              ),
              TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () async {
                    await showDailyMonthPicker(
                      context: context,
                      initialDate: now,
                    ).then(
                      (month) {
                        if (month != null) {
                          ref.read(_selectedMonthProvider.notifier).state =
                              month;
                        }
                      },
                    );
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 26,
                  ),
                  label: Text(
                    DateFormat('MMM').format(now).toUpperCase(),
                    style: FontsDaily.bigTitle,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Expenses",
                  style: FontsDaily.titleSubText,
                ),
                Text(
                  monthlyExpense.toStringAsFixed(2),
                  style: FontsDaily.bigTitle,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Income",
                  style: FontsDaily.titleSubText,
                ),
                Text(
                  monthlyIncome.toStringAsFixed(2),
                  style: FontsDaily.bigTitle,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Balance",
                  style: FontsDaily.titleSubText,
                ),
                Text(
                  monthlyBalance.toStringAsFixed(2),
                  style: FontsDaily.bigTitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
