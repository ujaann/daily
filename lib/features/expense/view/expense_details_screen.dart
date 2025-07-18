import 'package:daily/entity/expense.dart';
import 'package:daily/features/expense/data/expense_repo.dart';
import 'package:daily/features/expense/view/edit_expense_screen.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseDetailsScreen extends ConsumerWidget {
  final ExpenseEntity expense;
  const ExpenseDetailsScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 28,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type',
                        style: FontsDaily.bigTitle
                            .copyWith(fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    Text('Amount',
                        style: FontsDaily.bigTitle
                            .copyWith(fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    Text('Category',
                        style: FontsDaily.bigTitle
                            .copyWith(fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    Text('Date',
                        style: FontsDaily.bigTitle
                            .copyWith(fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    Text('Note',
                        style: FontsDaily.bigTitle
                            .copyWith(fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    // Text('User id',
                    //     style: FontsDaily.bigTitle
                    //         .copyWith(fontWeight: FontWeight.w300)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        expense.type.name.isNotEmpty
                            ? expense.type.name[0].toUpperCase() +
                                expense.type.name.substring(1)
                            : '',
                        style: FontsDaily.bigTitle
                            .copyWith(fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    Text(expense.amount.toString(),
                        style: FontsDaily.bigTitle
                            .copyWith(fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    Text(expense.category,
                        style: FontsDaily.bigTitle
                            .copyWith(fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    Text(DateFormat('yyyy-MM-dd').format(expense.date),
                        style: FontsDaily.bigTitle
                            .copyWith(fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    Text(expense.note,
                        style: FontsDaily.bigTitle
                            .copyWith(fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    // Text(expense.userId,
                    //     style: FontsDaily.bigTitle
                    //         .copyWith(fontWeight: FontWeight.w300)),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 24,
              children: [
                SizedBox(
                    width: 160,
                    height: 60,
                    child: ElevatedButton(
                        onPressed: () async {
                          await showConfirmationDialog(
                                  context: context,
                                  title: "Do you want to delete the record?")
                              .then(
                            (value) async {
                              if (value != null && value) {
                                await ref
                                    .read(expenseRepoProvider)
                                    .deleteExpense(expense);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                          );
                        },
                        child: Text(
                          "Delete",
                          style: FontsDaily.titleSubText,
                        ))),
                SizedBox(
                    width: 160,
                    height: 60,
                    child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditExpenseScreen(expense: expense),
                            )),
                        child: Text(
                          "Edit",
                          style: FontsDaily.titleSubText,
                        ))),
              ],
            ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
