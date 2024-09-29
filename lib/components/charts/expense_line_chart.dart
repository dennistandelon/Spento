import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spento/utils/expense.dart';

class ExpenseLineChart extends StatefulWidget {

  const ExpenseLineChart({super.key});

  @override
  State<ExpenseLineChart> createState() => _ExpenseLineChartState();
}

class _ExpenseLineChartState extends State<ExpenseLineChart> {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  List<Expense> expenseList = [];

  @override
  void initState() {
    super.initState();
    loadData(); 
  }

  Future<void> loadData() async {
    List<Expense> loadedExpenses = await loadExpenses();
    setState(() {
      expenseList = loadedExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
        maxWidth: 200,
      ),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16/9,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                 mainData(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    Map<int, double> monthlyTotals = calculateMonthlyTotals();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey,
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.grey,
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: monthlyTotals.values.reduce((a, b) => a > b ? a : b) + 10,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(12, (index) {
            int month = index + 1; 
            return FlSpot(month.toDouble(), monthlyTotals[month]!);
          }),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Map<int, double> calculateMonthlyTotals() {
    Map<int, double> monthlyTotals = {};
    
    for (var expense in expenseList) {
      int month = expense.expenseDate.month;
      double amount = expense.amount;

      if(expense.expenseDate.year != DateTime.now().year){
        continue;
      }

      if (monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = monthlyTotals[month]! + amount;
      } else {
        monthlyTotals[month] = amount;
      }
    }

    for (int i = 1; i <= 12; i++) {
      if (!monthlyTotals.containsKey(i)) {
        monthlyTotals[i] = 0.0;
      }
    }

    return monthlyTotals;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    String monthName;
    
    switch (value.toInt()) {
      case 1: monthName = 'JAN'; break;
      case 2: monthName = 'FEB'; break;
      case 3: monthName = 'MAR'; break;
      case 4: monthName = 'APR'; break;
      case 5: monthName = 'MAY'; break;
      case 6: monthName = 'JUN'; break;
      case 7: monthName = 'JUL'; break;
      case 8: monthName = 'AUG'; break;
      case 9: monthName = 'SEP'; break;
      case 10: monthName = 'OCT'; break;
      case 11: monthName = 'NOV'; break;
      case 12: monthName = 'DEC'; break;
      default: monthName = ''; break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(monthName, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    return Text('${value.toStringAsFixed(0)}', style: style);
  }
}
