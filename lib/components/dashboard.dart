import 'package:flutter/material.dart';
import 'package:spento/components/charts/expense_line_chart.dart';
import 'package:spento/components/charts/expense_pie_chart.dart'; 
import 'package:spento/utils/expense.dart';

class Dashboard extends StatelessWidget {
  final List<Expense> expenseList;

  const Dashboard({super.key, required this.expenseList});

  @override
  Widget build(BuildContext context) {

    String monthlyTitle = DateTime.now().year.toString() + ' Monthly Total Expenses';
    
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), 
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            ChartWrapper(title: 'Category Overview', childx: ExpensePieChart(expenseList: expenseList),),
            ChartWrapper(title: monthlyTitle, childx: ExpenseLineChart(),),
          ],
        );
      }
    );
  }
}

class ChartWrapper extends StatelessWidget{
  final Widget childx; 
  final String title;

  ChartWrapper({required this.childx, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 1.5,
          child: childx,
        ),
      ],
    );
  }
}