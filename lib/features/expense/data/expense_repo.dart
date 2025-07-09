import 'package:calendar_view/calendar_view.dart';
import 'package:daily/auth/auth_service.dart';
import 'package:daily/entity/expense.dart';
import 'package:daily/hive/hive_boxes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_repo.g.dart';

@riverpod
Box<ExpenseEntity> _expenseBox(Ref ref) {
  return Hive.box<ExpenseEntity>(HiveBoxes.expenseBox);
}

@riverpod
ExpenseRepo expenseRepo(Ref ref) {
  final box = ref.watch(_expenseBoxProvider);
  final auth = ref.watch(authServiceProvider);
  final userId = auth?.username;
  return ExpenseRepo(box, userId);
}

class ExpenseRepo {
  final Box<ExpenseEntity> box;
  final String? userId;

  ExpenseRepo(this.box, this.userId);

  List<ExpenseEntity> getExpenses() {
    if (userId == null) return [];
    return box.values.where((e) => e.userId == userId).toList();
  }

  Map<WeekDays, List<ExpenseEntity>> getWeeklyExpenses(
      DateTime start, DateTime end) {
    if (userId == null) return {};

    // Initialize map with empty lists for each weekday
    final Map<WeekDays, List<ExpenseEntity>> weeklyExpenses = {
      for (var day in WeekDays.values) day: [],
    };

    for (final expense in box.values) {
      if (expense.userId == userId && expense.date.isBetween(start, end)) {
        final weekday = WeekDays.values[expense.date.weekday - 1];
        weeklyExpenses[weekday]?.add(expense);
      }
    }
    return weeklyExpenses;
  }

  void addExpense(ExpenseEntity expense) {
    box.add(expense.copyWith(userId: userId));
  }

  Future<void> deleteExpense(ExpenseEntity expense) async {
    await box.delete(expense.key);
  }

  Future<void> updateExpense(ExpenseEntity expense,
      {ExpenseType? type,
      double? amount,
      String? category,
      DateTime? date,
      String? userId,
      String? title,
      String? note}) async {
    final updatedExpense = expense.copyWith(
      type: type,
      amount: amount,
      category: category,
      date: date,
      userId: userId,
      note: note,
    );

    await box.put(expense.key, updatedExpense);
  }
}
