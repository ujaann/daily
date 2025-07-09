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

class EditExpenseScreen extends ConsumerStatefulWidget {
  final ExpenseEntity expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  ConsumerState<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize state based on the passed-in expense
    Future.microtask(() {
      ref.read(_expenseInfo.notifier).state = widget.expense.category;
      ref.read(_expenseOrIncome.notifier).state =
          widget.expense.type == ExpenseType.income ? 1 : 0;
      ref
          .read(calcNotfierProvider.notifier)
          .init(widget.expense.amount.toString());
      ref.read(noteControllerProvider).text = widget.expense.note;
      ref.read(newExpenseDateProvider.notifier).state = widget.expense.date;
    });
  }

  bool submit(BuildContext context) {
    final amount = ref.read(calcNotfierProvider);
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

    ref.read(expenseRepoProvider).updateExpense(
          widget.expense,
          amount: parsedAmount,
          note: noteController.text,
          type: expenseType == 1 ? ExpenseType.income : ExpenseType.expense,
          category: title,
          date: date,
        );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(_expenseOrIncome);

    ref.watch(calcNotfierProvider.notifier);
    ref.watch(noteControllerProvider);
    ref.watch(newExpenseDateProvider.notifier);
    return DefaultTabController(
      length: 2,
      initialIndex: widget.expense.type == ExpenseType.income ? 1 : 0,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: const Text("Edit Expense"),
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
        ),
        body: Column(children: [
          Expanded(
            child: TabBarView(
              children: [
                EditExpenseIcons(),
                EditIncomeIcons(),
              ],
            ),
          ),
          if (ref.watch(_expenseInfo) != null)
            CustomKeyboard(
              onSubmit: () => submit(context),
            ),
        ]),
      ),
    );
  }
}

class EditExpenseIcons extends ConsumerWidget {
  const EditExpenseIcons({
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

class EditIncomeIcons extends ConsumerWidget {
  const EditIncomeIcons({
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
