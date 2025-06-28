import 'package:daily/entity/expense.dart';
import 'package:daily/features/expense/data/expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_screen.g.dart';

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
    final expenses = ref.watch(userExpensesProvider("Ujan"));

    return ListView.builder(
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
    );
  }
}
