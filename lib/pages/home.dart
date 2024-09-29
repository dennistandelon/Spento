import 'package:flutter/material.dart';
import 'package:spento/components/card.dart';
import 'package:spento/components/dashboard.dart';
import 'package:spento/utils/expense.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Expense> expenseList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData(); 
  }

  Future<void> loadData() async {
    List<Expense> loadedExpenses = await loadExpenses();
    setState(() {
      expenseList = loadedExpenses;
      isLoading = false;
    });
  }

  int calculateTodayExpenses() {
    DateTime today = DateTime.now(); 

    if (expenseList.isEmpty) {
      return 0;
    }

    return expenseList
        .where((expense) => 
            expense.expenseDate.day == today.day && 
            expense.expenseDate.month == today.month && 
            expense.expenseDate.year == today.year)
        .fold(0, (sum, expense) => sum + expense.amount.toInt());
  }

  int calculateThisMonthExpenses() {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    if (expenseList.isEmpty) return 0;

    return expenseList
        .where((expense) => 
            expense.expenseDate.month == currentMonth && 
            expense.expenseDate.year == currentYear)
        .fold(0, (sum, expense) => sum + expense.amount.toInt());
  }

  int calculateTotalExpenses() {
    if (expenseList.isEmpty) return 0;

    return expenseList.fold(0, (sum, expense) => sum + expense.amount.toInt());
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()), 
      );
    }

    int todayExpense = calculateTodayExpenses();
    int thisMonthExpense = calculateThisMonthExpenses();
    int totalExpense = calculateTotalExpenses();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Spento!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Track your expenses effortlessly.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 16), 
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    AggregateCard(
                      title: 'Today\'s Expense',
                      amount: 'Rp ${todayExpense}',
                      icon: Icons.money,
                    ),
                    AggregateCard(
                      title: 'This Month\'s Expense',
                      amount: 'Rp ${thisMonthExpense}',
                      icon: Icons.calendar_today, 
                    ),
                    AggregateCard(
                      title: 'Total Expense',
                      amount: 'Rp ${totalExpense}',
                      icon: Icons.trending_up,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Dashboard(expenseList: expenseList),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
