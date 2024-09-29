import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spento/utils/expense.dart';

class ExpensePieChart extends StatelessWidget {
  final List<Expense> expenseList;

  const ExpensePieChart({super.key, required this.expenseList});

  Color getRandomColor() {
    return Colors.primaries[Random(DateTime.now().millisecond).hashCode % Colors.primaries.length];
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryTotals = {};

    for (var expense in expenseList) {
      if (categoryTotals.containsKey(expense.type)) {
        categoryTotals[expense.type] = (categoryTotals[expense.type] ?? 0) + expense.amount;
      } else {
        categoryTotals[expense.type] = expense.amount;
      }
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
        maxWidth: 200,
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: categoryTotals.entries.map((entry) {
            return PieChartSectionData(
              showTitle: true,
              color: getRandomColor(), 
              value: entry.value,
              title: entry.key,
              radius: 100,
              titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            );
          }).toList(),
        ),
      )
    );
  }
}