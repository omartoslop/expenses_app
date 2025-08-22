import 'package:expenses_app/models/expense.dart';

import 'expenses.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _SsubmitExpenseData() {
    final enteredAmount = double.tryParse(_valueController.text);
    final amountIsValid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('invalid Imput'),
          content: Text(
            'make sure that title , amount , date and category are setted before submitting your expense',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Okey'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
        amount: enteredAmount,
        date: _selectedDate!,
        title: _titleController.text,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kbSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constrains) {
        final width = constrains.maxWidth;
        final height = constrains.maxHeight;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, kbSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Set the name of your expense'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          controller: _valueController,
                          maxLength: 15,
                          decoration: const InputDecoration(
                            label: Text('Amount'),
                            prefixText: '\$',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Set the name of your expense'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'no date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _valueController,
                          maxLength: 15,
                          decoration: const InputDecoration(
                            label: Text('Amount'),
                            prefixText: '\$',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'no date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _SsubmitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _SsubmitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
