// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import '../../../database/db_manage.dart';
// import 'package:flutter/services.dart';
// import 'page4.dart';
//
// class AddBudget extends StatefulWidget {
//   final String valued;
//
//   AddBudget({required this.valued});
//
//   @override
//   _AddBudgetState createState() => _AddBudgetState();
// }
//
// class _AddBudgetState extends State<AddBudget> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   final TextEditingController _amountController = TextEditingController();
//
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now().add(Duration(days: 30)); // ค่าเริ่มต้นของ End Date
//   String _typeTransactionName = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadTypeTransactionName();
//   }
//
//   Future<void> _loadTypeTransactionName() async {
//     int id = int.parse(widget.valued);
//     String? name = await DatabaseManagement.instance.getTypeTransactionNameById(id);
//     setState(() {
//       _typeTransactionName = name ?? 'Unknown';
//     });
//   }
//
//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Budget'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // ปิดหน้า AddTransaction และย้อนกลับไปที่หน้าเดิม
//           },
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(10),
//         child: FormBuilder(
//           key: _formKey,
//           child: Column(
//             children: [
//               Text(
//                 '$_typeTransactionName', // ใช้ชื่อ TypeTransaction
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               FormBuilderDateTimePicker(
//                 name: 'startDate',
//                 initialValue: _startDate,
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(2100),
//                 inputType: InputType.date,
//                 decoration: InputDecoration(
//                   labelText: 'Start Date',
//                   suffixIcon: Icon(Icons.calendar_today),
//                 ),
//                 locale: Locale('th'),
//                 onChanged: (value) {
//                   if (value != null) {
//                     setState(() {
//                       _startDate = value;
//                       _endDate = value.add(Duration(days: 30)); // ปรับค่า End Date ให้เป็น Start Date + 30 วัน
//                     });
//                   }
//                 },
//               ),
//               FormBuilderDateTimePicker(
//                 name: 'endDate',
//                 initialValue: _endDate, // ใช้ค่า End Date ที่คำนวณจาก Start Date + 30 วัน
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(2100),
//                 inputType: InputType.date,
//                 decoration: InputDecoration(
//                   labelText: 'End Date',
//                   suffixIcon: Icon(Icons.calendar_today),
//                 ),
//                 locale: Locale('th'),
//               ),
//               FormBuilderTextField(
//                 name: 'amountController',
//                 controller: _amountController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Amount of Money',
//                   border: UnderlineInputBorder(), // เปลี่ยนเป็นเส้นใต้
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the amount of money';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.saveAndValidate()) {
//                     var startDate = _formKey.currentState?.value['startDate'];
//                     var endDate = _formKey.currentState?.value['endDate'];
//                     var category = widget.valued;
//                     var capitalBudget = _amountController.text;
//
//                     // ปรับค่า startDate ให้เป็นเวลาเที่ยงคืน
//                     startDate = DateTime(startDate.year, startDate.month, startDate.day);
//
//                     // ข้อมูลที่ต้องการบันทึก
//                     Map<String, dynamic> row = {
//                       'date_start': startDate.toString(),
//                       'date_end': endDate.toString(),
//                       'capital_budget': double.parse(capitalBudget),
//                       'ID_type_transaction': category,
//                     };
//                     // บันทึกข้อมูลลงฐานข้อมูล
//                     await DatabaseManagement.instance.insertBudget(row);
//
//                     // กลับไปหน้าก่อนหน้าและส่งค่า
//                     Navigator.pop(context, true);
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }