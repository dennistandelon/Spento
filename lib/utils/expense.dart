import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Expense{
  final String id;
  String description;
  String type;
  double amount;
  DateTime expenseDate;
  String notes;

  Expense({String? id,required this.description, required this.type, required this.amount, required this.expenseDate, String? notes}): id = id ?? Uuid().v4(), notes = notes ?? "";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'type': type,
      'amount': amount,
      'expenseDate': expenseDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      expenseDate: DateTime.parse(json['expenseDate'] as String),
      notes: json['notes'] as String,
    );
  }
}


Future<void> saveExpenses(List<Expense> expenses) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  List<Map<String, dynamic>> jsonList = expenses.map((expense) => expense.toJson()).toList();
  String jsonString = jsonEncode(jsonList);

  await prefs.setString('expenses', jsonString);
}

Future<List<Expense>> loadExpenses() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? jsonString = prefs.getString('expenses');
  
  if (jsonString != null) {
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Expense.fromJson(json)).toList();
  }
  
  return []; 
}
