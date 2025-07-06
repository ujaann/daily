import 'package:daily/entity/expense.dart';
import 'package:daily/features/expense/data/expense_repo.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/custom_keyboard.dart';
import 'package:daily/util/dependencies.dart';
import 'package:daily/util/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _expenseInfo = StateProvider.autoDispose<String?>((ref) => null);
final _expenseOrIncome = StateProvider.autoDispose<int>((ref) => 0);

class NewExpenseScreen extends ConsumerWidget {
  const NewExpenseScreen({super.key});

  bool submit(WidgetRef ref, BuildContext context) {
    final amount = ref.read(amountProvider);
    final noteController = ref.read(noteControllerProvider);
    final expenseType = ref.read(_expenseOrIncome);
    final date = ref.read(newExpenseDateProvider);
    final title = ref.read(_expenseInfo);
    final parsedAmount = double.tryParse(amount);

    if (noteController.text.isEmpty) {
      showErrorSnackbar(context, "Please write a note");
      return false;
    } else if (parsedAmount == null || parsedAmount <= 0) {
      showErrorSnackbar(context, "Please enter a valid amount");
      return false;
    } else if (title == null) {
      showErrorSnackbar(context, "Please select a category");
      return false;
    }

    ref.read(expenseRepoProvider).addExpense(
          ExpenseEntity(
            amount: parsedAmount,
            category: title,
            date: date,
            type: expenseType == 1 ? ExpenseType.income : ExpenseType.expense,
            userId: "Ujan",
            note: noteController.text,
          ),
        );
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: const Text("New Expense"),
          bottom: TabBar(
            labelColor: Colors.white,
            onTap: (value) {
              ref.read(_expenseOrIncome.notifier).state = value;
              ref.read(_expenseInfo.notifier).state = null;
            },
            tabs: [
              Tab(text: 'Expense'),
              Tab(text: 'Income'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () async {},
              icon: const Icon(Icons.done),
            )
          ],
        ),
        body: Column(children: [
          Expanded(
            child: TabBarView(
              children: [
                ExpenseIcons(),
                IncomeIcons(),
              ],
            ),
          ),
          if (ref.watch(_expenseInfo) != null)
            CustomKeyboard(
              onSubmit: () => submit(ref, context),
            ),
        ]),
      ),
    );
  }
}

class ExpenseIcons extends ConsumerWidget {
  const ExpenseIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(8),
      children: expenseIconMap.entries.map((entry) {
        final label = entry.key;
        final emoji = entry.value;
        return InkWell(
          onTap: () {
            ref.read(_expenseInfo.notifier).state = label;
          },
          child: ColoredBox(
            color: ref.watch(_expenseInfo) == label
                ? ColorsDaily.cream
                : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  emoji,
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class IncomeIcons extends ConsumerWidget {
  const IncomeIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(8),
      children: incomeIconMap.entries.map((entry) {
        final label = entry.key;
        final emoji = entry.value;
        return InkWell(
          onTap: () {
            ref.read(_expenseInfo.notifier).state = label;
          },
          child: ColoredBox(
            color: ref.watch(_expenseInfo) == label
                ? ColorsDaily.cream
                : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  emoji,
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
