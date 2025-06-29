import 'package:hive_ce/hive.dart';

class ExpenseEntity extends HiveObject {
  final ExpenseType type;
  final double amount;
  final String category;
  final DateTime date;
  final String userId;
  final String title;
  final String note;

  ExpenseEntity(
      {required this.amount,
      required this.category,
      required this.date,
      required this.type,
      required this.title,
      required this.userId,
      required this.note});

  ExpenseEntity copyWith({
    ExpenseType? type,
    double? amount,
    String? category,
    DateTime? date,
    String? userId,
    String? title,
    String? note,
  }) =>
      ExpenseEntity(
        type: type ?? this.type,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        date: date ?? this.date,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        note: note ?? this.note,
      );
}

enum ExpenseType { expense, income }
