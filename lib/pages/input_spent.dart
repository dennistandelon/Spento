import 'package:flutter/material.dart';
import 'package:spento/utils/expense.dart';

class InputSpent extends StatefulWidget {
  @override
  _InputSpentState createState() => _InputSpentState();
}

class _InputSpentState extends State<InputSpent> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  String? _errorMessage;

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

  final List<String> types = ['Food', 'Transportation', 'Bills', 'Entertainment'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate, 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2101),  
    );

    if (pickedDate != null && pickedDate != _selectedDate){
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _addHistory(Expense ex) {
    setState(() {
      _errorMessage = null; 
    });

    if (_descController.text.isEmpty) {
      setState(() {
        _errorMessage = "Title cannot be empty!";
      });
      return;
    }
    if (_amountController.text.isEmpty || double.tryParse(_amountController.text) == null) {
      setState(() {
        _errorMessage = "Please enter a valid amount!";
      });
      return;
    }

    expenseList.add(ex);
    saveExpenses(expenseList);

    _amountController.text = "";
    _descController.text = "";
    _selectedCategory = "Food";
    _selectedDate = DateTime.now();


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Expense Add successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Card(
          elevation: 8,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Expense Title',
                    labelStyle: TextStyle(color: Colors.blue),
                    hintText: 'Enter your expense title',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 16), 
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.blue),
                    hintText: 'Ex: 1000',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16), 
                Text(
                  'Selected Category', 
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 11, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.blue, width: 2.0),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: types.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child:Text(value)
                        ),
                      );
                    }).toList(),
                    isExpanded: true, 
                    underline: Container(),
                    elevation: 4,
                    menuMaxHeight: 200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 16), 
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.blue, width: 2.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                        style: TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('Pick Date', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16), 
                ElevatedButton(
                  onPressed: () {
                      _addHistory(Expense(
                          description: _descController.text,
                          type: _selectedCategory,
                          amount: double.tryParse(_amountController.text) ?? 0,
                          expenseDate: _selectedDate,
                        ),
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (_errorMessage != null) 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
