import 'package:flutter/material.dart';
import 'package:spento/pages/expense_view.dart';
import 'package:spento/pages/home.dart';
import 'package:spento/pages/input_spent.dart';

final List<Widget> pages = <Widget>[
  HomePage(title: 'Your Dashboard'),
  InputSpent(),
  ExpenseView(),
];

final List<Map<String,dynamic>> pageLists = [
  {'title': 'Dashboard', 'icon': Icons.home},
  {'title': 'Add Expense', 'icon': Icons.add},
  {'title': 'History', 'icon': Icons.history},
];

final List<BottomNavigationBarItem> navItems =[
  for (var x in pageLists) BottomNavigationBarItem(
    icon: Icon(x['icon']),
    label: x['title'],
  ),
];
