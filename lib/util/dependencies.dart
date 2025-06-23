import 'package:daily/entity/expense.dart';
import 'package:daily/hive/hive_boxes.dart';
import 'package:daily/hive/hive_registrar.g.dart';
import 'package:hive_ce_flutter/adapters.dart';

Future<void> hiveInit() async {
  await Hive.initFlutter();
  Hive.registerAdapters();

  await Hive.openBox<ExpenseEntity>(HiveBoxes.expenseBox);
}
