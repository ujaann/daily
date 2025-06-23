import 'package:daily/entity/expense.dart';
import 'package:daily/features/expense/data/expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_screen.g.dart';

@riverpod
Stream<List<ExpenseEntity>> userExpenses(Ref ref, String userId) {
  final repo = ref.watch(expenseRepoProvider);
  return repo.watchExpenses(userId);
}

class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(userExpensesProvider("Ujan"));

    return expensesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text("Error: $e")),
      data: (expenses) => ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];

          return ListTile(
            leading: Text('$index'),
            title: Text(expense.title),
            trailing: Text(
              '${expense.type == ExpenseType.expense ? '-' : ''}${expense.amount}',
            ),
          );
        },
      ),
    );
  }
}
