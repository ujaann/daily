import 'package:daily/entity/expense.dart';
import 'package:daily/hive/hive_boxes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_repo.g.dart';

@riverpod
Box<ExpenseEntity> _expenseBox(Ref ref) {
  return Hive.box<ExpenseEntity>(HiveBoxes.expenseBox);
}

@riverpod
ExpenseRepo expenseRepo(Ref ref) {
  final box = ref.watch(_expenseBoxProvider);
  return ExpenseRepo(box);
}

class ExpenseRepo {
  final Box<ExpenseEntity> box;

  ExpenseRepo(this.box);

  List<ExpenseEntity> getExpenses(String userId) {
    box.add(ExpenseEntity(
        amount: 1000,
        category: 'money',
        date: DateTime.now(),
        type: ExpenseType.expense,
        title: "👌Money",
        userId: "Ujan",
        note: "OOps"));
    return box.values.where((e) => e.userId == userId).toList();
  }

  Stream<List<ExpenseEntity>> watchExpenses(String userId) {
    return box.watch().map((_) {
      return box.values.where((e) => e.userId == userId).toList();
    });
  }

  void addExpense(ExpenseEntity expense) {
    box.add(expense);
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
      title: title,
      note: note,
    );

    await box.put(expense.key, updatedExpense);
  }
}
