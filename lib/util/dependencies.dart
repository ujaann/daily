import 'package:daily/entity/auth.dart';
import 'package:daily/entity/event.dart';
import 'package:daily/entity/expense.dart';
import 'package:daily/entity/user.dart';
import 'package:daily/hive/hive_boxes.dart';
import 'package:daily/hive/hive_registrar.g.dart';
import 'package:daily/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';

Future<void> hiveInit() async {
  await Hive.initFlutter();
  Hive.registerAdapters();

  await Hive.openBox<ExpenseEntity>(HiveBoxes.expenseBox);
  await Hive.openBox<EventEntity>(HiveBoxes.eventBox);
  await Hive.openBox<UserEntity>(HiveBoxes.userBox);
  await Hive.openBox<AuthEntity>(HiveBoxes.authBox);
}

Future<void> notifyInit() async {
  print("notifications inti");
  NotifyService().initNotification();
}

const Map<String, String> expenseMap = {
  'Food': '🍔',
  'Grocery': '🥦',
  'Clothes': '👕',
  'Tech': '📱',
  'Transport': '🚗',
  'Rent': '🏠',
  'Utilities': '💡',
  'Health': '💊',
  'Gifts': '🎁',
  'Education': '📚',
  'Entertainment': '🎮',
  'Pets': '🐶',
  'Travel': '✈️',
  'Hygiene': '🧼',
  'Work': '💼',
  'Repairs': '🛠️',
  'Self-car:': '💅',
  'Drinks': '🍻',
  'Fitness': '🏋️‍♂️',
  'Shopping': '🛒',
};

const Map<String, IconData> expenseIconMap = {
  'Food': Icons.fastfood,
  'Grocery': Icons.local_grocery_store,
  'Clothes': Icons.checkroom,
  'Tech': Icons.devices,
  'Transport': Icons.directions_car,
  'Rent': Icons.home,
  'Utilities': Icons.lightbulb,
  'Health': Icons.medication,
  'Gifts': Icons.card_giftcard,
  'Education': Icons.school,
  'Entertainment': Icons.sports_esports,
  'Pets': Icons.pets,
  'Travel': Icons.flight,
  'Work': Icons.work,
  'Repairs': Icons.build,
  'Self-care': Icons.spa,
  'Drinks': Icons.local_bar,
  'Fitness': Icons.fitness_center,
  'Shopping': Icons.shopping_cart,
  'Others': Icons.more_horiz,
};

const Map<String, IconData> incomeIconMap = {
  'Salary': Icons.attach_money,
  'Bonus': Icons.celebration,
  'Freelance': Icons.computer,
  'Investment': Icons.trending_up,
  'Gifts': Icons.card_giftcard,
  'Refunds': Icons.receipt, // or Icons.money_off if preferred
  'Selling': Icons.store,
  'Rental Income': Icons.home_work,
  'Royalties': Icons.library_books,
  'Others': Icons.more_horiz,
};

//Unused code
// Map<WeekDays, (double, double)> getWeeklyData(WidgetRef ref) {
//     final today = DateTime.now();

//     final data = ref
//         .read(expenseRepoProvider)
//         .getWeeklyExpenses(today.firstDayOfWeek(), today.lastDayOfWeek());

//     return {
//       for (final entry in data.entries)
//         entry.key: (
//           entry.value
//               .where((e) => e.type == ExpenseType.expense)
//               .fold(0.0, (sum, e) => sum + e.amount),
//           entry.value
//               .where((e) => e.type == ExpenseType.income)
//               .fold(0.0, (sum, e) => sum + e.amount)
//         )
//     };
//   }

//   (Map<String, double>, Map<String, double>) getCurrentMonthData(
//       List<ExpenseEntity> data) {
//     final Map<String, double> expenseMap = {};
//     final Map<String, double> incomeMap = {};

//     for (final item in data) {
//       final category = item.category;
//       final amount = item.amount;

//       if (item.type == ExpenseType.expense) {
//         expenseMap[category] = (expenseMap[category] ?? 0) + amount;
//       } else if (item.type == ExpenseType.income) {
//         incomeMap[category] = (incomeMap[category] ?? 0) + amount;
//       }
//     }
//     return (expenseMap, incomeMap);
//   }

//   Map<int, (double, double)> getMonthlyData(WidgetRef ref) {
//     final data = ref.read(expenseRepoProvider).getExpenses();
//     final Map<int, List<ExpenseEntity>> monthlyExpenses = {
//       for (var i = 1; i < 13; i++) i: [],
//     };
//     for (final expense in data) {
//       monthlyExpenses[expense.date.month]?.add(expense);
//     }
//     return {
//       for (final entry in monthlyExpenses.entries)
//         entry.key: (
//           entry.value
//               .where((e) => e.type == ExpenseType.expense)
//               .fold(0.0, (sum, e) => sum + e.amount),
//           entry.value
//               .where((e) => e.type == ExpenseType.income)
//               .fold(0.0, (sum, e) => sum + e.amount)
//         )
//     };
//   }
