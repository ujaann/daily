import 'package:daily/features/graphs/bar_chart.dart';
import 'package:daily/features/graphs/pie_chart.dart';
import 'package:flutter/material.dart';

class GraphsScreen extends StatelessWidget {
  const GraphsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          // ToggleButtons(
          //   isSelected: [true, false],
          //   onPressed: (int index) {
          //     // Implement state management to handle toggle selection
          //   },
          //   children: const [
          //     Text('Expense'),
          //     Text('Income'),
          //   ],
          // ),
          // const SizedBox(height: 12),
          BarChartSample2(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              spacing: 24,
              children: [
                Indicator(
                    color: Colors.red, text: "Expenses ", isSquare: false),
                Indicator(
                    color: Colors.green, text: "Incomes ", isSquare: false),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text("Monthly expenses", style: TextStyle(fontSize: 22)),
          PieChartSample2(),
        ],
      ),
    );
  }
}
