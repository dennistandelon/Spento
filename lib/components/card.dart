import 'package:flutter/material.dart';
import 'package:spento/utils/expense.dart';

class ExpenseCard extends StatelessWidget{

  final Expense data;

  const ExpenseCard({super.key, required this.data});

  @override
  Widget build(BuildContext context){
    return Card(
      elevation: 4, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), 
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), 
      child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.description, 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8), 
            Text(
              'Rp. ${data.amount.toStringAsFixed(2)}', 
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            SizedBox(height: 4), 
            Text(
              data.expenseDate.toString(), 
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class AggregateCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData? icon; 

  AggregateCard({required this.title, required this.amount, this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 30, 
                color: Colors.blue, 
              ),
            SizedBox(height: icon != null ? 8 : 0), 
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87, 
              ),
              textAlign: TextAlign.center, 
            ),
            SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
