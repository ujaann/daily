import 'package:daily/entity/event.dart';
import 'package:daily/entity/expense.dart';
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
  await Hive.openBox<EventEntity>(HiveBoxes.userBox);
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
