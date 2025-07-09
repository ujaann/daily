import 'package:calendar_view/calendar_view.dart';
import 'package:daily/entity/expense.dart';
import 'package:daily/features/expense/data/expense_repo.dart';
import 'package:daily/features/expense/view/expense_details_screen.dart';
import 'package:daily/util/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  ExpenseType? _selectedChipper;

  @override
  Widget build(BuildContext context) {
    final allexpenses = ref.watch(expenseRepoProvider).getExpenses();

    final filteredList = allexpenses.where(
      (item) {
        final matchesChip =
            _selectedChipper == null || item.type == _selectedChipper;
        final matchesSearch = item.note
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        return matchesChip && matchesSearch;
      },
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            // Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text("All"),
                      selected: _selectedChipper == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedChipper = null;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text("Expense"),
                      selected: _selectedChipper == ExpenseType.expense,
                      onSelected: (selected) {
                        setState(() {
                          _selectedChipper = ExpenseType.expense;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text("Income"),
                      selected: _selectedChipper == ExpenseType.income,
                      onSelected: (selected) {
                        setState(() {
                          _selectedChipper = ExpenseType.income;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final expense = filteredList.elementAt(index);
                  final icon = switch (expense.type) {
                    ExpenseType.expense => expenseIconMap[expense.category],
                    ExpenseType.income => incomeIconMap[expense.category],
                  };

                  // Track last grouped date locally
                  final isFirst = index == 0;
                  final previous = !isFirst ? filteredList[index - 1] : null;

                  final shouldAddHeader = isFirst ||
                      !(expense.date.compareWithoutTime(previous!.date));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (shouldAddHeader)
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Text(
                              DateFormat('MMM d, yyyy').format(expense.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                            )),
                      ListTile(
                        leading: Icon(icon),
                        title: Text(expense.note),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ExpenseDetailsScreen(expense: expense),
                            )),
                        trailing: Text(
                          '${expense.type == ExpenseType.expense ? '-' : ''}${expense.amount}',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
