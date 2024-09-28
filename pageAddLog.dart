import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../imageOCR/pick_picture.dart';
import '../../../database/db_manage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final ImageOcrHelper _imageOcrHelper = ImageOcrHelper();

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _pickImageAndExtractText() async {
    final extractedText = await _imageOcrHelper.pickImageAndExtractText();
    if (extractedText != null) {
      setState(() {
        _amountController.text = extractedText;
      });
    }
  }

  Future<void> _handleIncomingImage(String imageUri) async {
    final extractedText = await _imageOcrHelper.extractTextFromImage(imageUri);
    if (extractedText != null) {
      setState(() {
        _amountController.text = extractedText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? _sharingFile = ModalRoute.of(context)!.settings.arguments as String?;
    if (_sharingFile != null) {
      _handleIncomingImage(_sharingFile);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense & Income Log'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderChoiceChip<String>(
                name: 'transactionType',
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                spacing: 16.0,
                alignment: WrapAlignment.center,
                options: [
                  FormBuilderChipOption<String>(
                    value: "0",
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text("Income"),
                      ),
                    ),
                  ),
                  FormBuilderChipOption<String>(
                    value: "1",
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text("Expense"),
                      ),
                    ),
                  ),
                ],
                validator: FormBuilderValidators.required(
                  errorText: 'Please select a transaction type',
                ),
                onChanged: (value) {
                  setState(() {
                    if (value == "0") {
                      // ตั้งค่า type_expense เป็น 0 เมื่อเลือก Income
                      _formKey.currentState?.fields['category']?.didChange(null); // เคลียร์ค่า category
                    } else {
                      // เคลียร์ค่าเมื่อเลือก Expense
                      _formKey.currentState?.fields['category']?.didChange(null);
                    }
                  });
                },
              ),
              FormBuilderDateTimePicker(
                name: 'dateTimeController',
                initialValue: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                inputType: InputType.both,
                decoration: InputDecoration(
                  labelText: 'Appointment Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                initialTime: TimeOfDay(hour: 8, minute: 0),
                locale: Locale('th'),
              ),
              // แสดง Dropdown เมื่อเลือก Expense
              if (_formKey.currentState?.fields['transactionType']?.value == "1")
                FormBuilderDropdown<String>(
                  name: 'category',
                  decoration: InputDecoration(
                    labelText: 'Select Category',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'Null', child: Text('Please Select')),
                    DropdownMenuItem(value: 'Food', child: Text('Food')),
                    DropdownMenuItem(value: 'Travel expenses', child: Text('Travel expenses')),
                    DropdownMenuItem(value: 'Water bill', child: Text('Water bill')),
                    DropdownMenuItem(value: 'Electricity bill', child: Text('Electricity bill')),
                    DropdownMenuItem(value: 'House cost', child: Text('House cost')),
                    DropdownMenuItem(value: 'Car fare', child: Text('Car fare')),
                    DropdownMenuItem(value: 'Gasoline cost', child: Text('Gasoline cost')),
                    DropdownMenuItem(value: 'Medical expenses', child: Text('Medical expenses')),
                    DropdownMenuItem(value: 'Beauty expenses', child: Text('Beauty expenses')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  validator: FormBuilderValidators.required(
                    errorText: 'Please select a category',
                  ),
                ),
              FormBuilderTextField(
                name: 'amountController',
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Enter Amount of Money',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount of money';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              FormBuilderTextField(
                name: 'memoController',
                controller: _memoController,
                decoration: InputDecoration(
                  labelText: 'Memo',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              ElevatedButton(
                onPressed: _pickImageAndExtractText,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo),
                    SizedBox(width: 8),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    var typeExpense = _formKey.currentState?.value['transactionType'];
                    var date = _formKey.currentState?.value['dateTimeController'];
                    var category = _formKey.currentState?.value['category'];
                    var amount = _amountController.text;
                    var memo = _memoController.text;

                    // Get category ID
                    int? typeTransactionId = await DatabaseManagement.instance.getTypeTransactionId(category);

                    if (typeTransactionId == null && typeExpense == '1') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invalid category selected.'),
                        ),
                      );
                      return;
                    }

                    Map<String, dynamic> row = {
                      'date_user': date.toString(),
                      'amount_transaction': double.parse(amount),
                      'type_expense': typeExpense == '1' ? 1 : 0,
                      'memo_transaction': memo,
                      'ID_type_transaction': typeTransactionId ?? 0, // ตั้งค่าเป็น 0 หาก Income ไม่มี ID
                    };

                    await DatabaseManagement.instance.insertTransaction(row);
                    Navigator.pop(context, true);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
