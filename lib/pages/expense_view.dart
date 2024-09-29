import 'package:flutter/material.dart';
import 'package:spento/components/card.dart';
import 'package:spento/pages/expense_detail.dart';
import 'package:spento/utils/expense.dart';

class ExpenseView extends StatefulWidget{

  _ExpenseViewState createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView>{
  late List<Expense> expenseList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    
    List<Expense> data = await loadExpenses();

    setState(() {
      expenseList = data;
      expenseList.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    });
  }

  @override
  Widget build(BuildContext context){
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense History'),
        toolbarHeight: 60,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final data = expenseList[index];

                return InkWell(
                  onTap: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ExpenseDetailPage(data: data);
                    }));

                    if (result == true) {
                      setState(() {
                        expenseList.removeAt(index);
                      });
                      
                      await saveExpenses(expenseList);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Expense deleted successfully!')),
                      );
                    } else if (result is Expense) {
                      setState(() {
                        expenseList[index] = result;
                      });
                      
                      await saveExpenses(expenseList);
                    }
                  },
                  child: ExpenseCard(data: data),
                );
              },
              itemCount: expenseList.length,
            ),
          ),
        ],
      ),
    );
  }
}