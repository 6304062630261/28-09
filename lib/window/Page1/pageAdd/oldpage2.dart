// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:vongola/database/db_manage.dart';
// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
//
//
// //***************[ B A R C H A R T ]*****************************************
// Future<Map<String, double>> fetchIncomeExpenseFromDatabaseToday() async {
//   double totalIncome = 0;
//   double totalExpense = 0;
//
//   try {
//     // ดึงข้อมูลรายรับของวันปัจจุบัน
//     List<Map<String, dynamic>> incomeResult = await DatabaseManagement.instance.rawQuery(
//         'SELECT SUM(amount_transaction) AS total_income FROM transactions WHERE type_expense = 0 AND DATE(date_user) = DATE("now")'
//     );
//     totalIncome = (incomeResult[0]['total_income'] ?? 0).toDouble();
//
//     // ดึงข้อมูลรายจ่ายของวันปัจจุบัน
//     List<Map<String, dynamic>> expenseResult = await DatabaseManagement.instance.rawQuery(
//         'SELECT SUM(amount_transaction) AS total_expense FROM transactions WHERE type_expense = 1 AND DATE(date_user) = DATE("now")'
//     );
//     totalExpense = (expenseResult[0]['total_expense'] ?? 0).toDouble();
//   } catch (error) {
//     print("Error fetching data: $error");
//   }
//
//   return {
//     'totalIncome': totalIncome,
//     'totalExpense': totalExpense,
//   };
// }
//
//
// Future<Map<String, double>> fetchIncomeExpenseFromDatabaseMonth() async {
//   double totalIncome = 0;
//   double totalExpense = 0;
//
//   try {
//     // ดึงข้อมูลรายรับของเดือนปัจจุบัน
//     List<Map<String, dynamic>> incomeResult = await DatabaseManagement.instance.rawQuery(
//         'SELECT SUM(amount_transaction) AS total_income FROM transactions WHERE type_expense = 0 AND strftime("%m", date_user) = strftime("%m", "now") AND strftime("%Y", date_user) = strftime("%Y", "now")'
//     );
//     totalIncome = (incomeResult[0]['total_income'] ?? 0).toDouble();
//
//     // ดึงข้อมูลรายจ่ายของเดือนปัจจุบัน
//     List<Map<String, dynamic>> expenseResult = await DatabaseManagement.instance.rawQuery(
//         'SELECT SUM(amount_transaction) AS total_expense FROM transactions WHERE type_expense = 1 AND strftime("%m", date_user) = strftime("%m", "now") AND strftime("%Y", date_user) = strftime("%Y", "now")'
//     );
//     totalExpense = (expenseResult[0]['total_expense'] ?? 0).toDouble();
//   } catch (error) {
//     print("Error fetching data: $error");
//   }
//
//   return {
//     'totalIncome': totalIncome,
//     'totalExpense': totalExpense,
//   };
// }
//
// Future<Map<String, double>> fetchIncomeExpenseFromDatabaseYear() async {
//   double totalIncome = 0;
//   double totalExpense = 0;
//
//   try {
//     // ดึงข้อมูลรายรับของปีปัจจุบัน
//     List<Map<String, dynamic>> incomeResult = await DatabaseManagement.instance.rawQuery(
//         'SELECT SUM(amount_transaction) AS total_income '
//             'FROM transactions '
//             'WHERE type_expense = 0 '
//             'AND strftime("%Y", date_user) = strftime("%Y", "now")'  // เงื่อนไขสำหรับดึงข้อมูลเฉพาะปีปัจจุบัน
//     );
//     totalIncome = (incomeResult[0]['total_income'] ?? 0).toDouble();
//
//     // ดึงข้อมูลรายจ่ายของปีปัจจุบัน
//     List<Map<String, dynamic>> expenseResult = await DatabaseManagement.instance.rawQuery(
//         'SELECT SUM(amount_transaction) AS total_expense '
//             'FROM transactions '
//             'WHERE type_expense = 1 '
//             'AND strftime("%Y", date_user) = strftime("%Y", "now")'  // เงื่อนไขสำหรับดึงข้อมูลเฉพาะปีปัจจุบัน
//     );
//     totalExpense = (expenseResult[0]['total_expense'] ?? 0).toDouble();
//   } catch (error) {
//     print("Error fetching data: $error");
//   }
//
//   return {
//     'totalIncome': totalIncome,
//     'totalExpense': totalExpense,
//   };
// }
//
// // ฟังก์ชันดึงข้อมูลจากฐานข้อมูล
// Future<Map<String, double>> fetchIncomeExpenseFromDatabase() async {
//   double totalIncome = 0;
//   double totalExpense = 0;
//
//   try {
//     // ดึงข้อมูลรายการทั้งหมด
//     List<Map<String, dynamic>> transactions = await DatabaseManagement.instance.queryAllTransactions();
//
//     for (var transaction in transactions) {
//       double amount = transaction['amount_transaction'];
//       bool isExpense = transaction['type_expense'] == 1;
//
//       if (isExpense) {
//         totalExpense += amount;
//       } else {
//         totalIncome += amount;
//       }
//     }
//   } catch (error) {
//     print("Error fetching data: $error");
//   }
//
//   return {
//     'totalIncome': totalIncome,
//     'totalExpense': totalExpense,
//   };
// }
//
//
// void _showFinancialBarChart(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Select Time Range'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   Map<String, double> data = await fetchIncomeExpenseFromDatabaseToday();
//                   _showBarChartDialog(context, data);
//                 },
//                 child: Text('Day'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   Map<String, double> data = await fetchIncomeExpenseFromDatabaseMonth();
//                   _showBarChartDialog(context, data);
//                 },
//                 child: Text('Month'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   Map<String, double> data = await fetchIncomeExpenseFromDatabaseYear();
//                   _showBarChartDialog(context, data);
//                 },
//                 child: Text('Year'),
//               ),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//         ],
//       );
//     },
//   );
// }
//
// void _showBarChartDialog(BuildContext context, Map<String, double> data) {
//   double totalIncome = data['totalIncome'] ?? 0;
//   double totalExpense = data['totalExpense'] ?? 0;
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Financial Bar Chart'),
//         content: FinancialBarChart(
//           totalIncome: totalIncome,
//           totalExpense: totalExpense,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Close'),
//           ),
//         ],
//       );
//     },
//   );
// }
//
// //*********************[P I E C H A R T]*************************************
//
//
//
// //*********************[P I E C H A R T]*************************************
//
//
//
//
//
// void _showFinancialPieChart(BuildContext context) {
//   showDialog(
//
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Select Time Range'),
//
//         content: SingleChildScrollView(
//
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   await _showFinancialChart(context,  calculateFinancialData_Day());
//                 },
//                 child: Text('Day'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   await _showFinancialChart(context, calculateFinancialData_Month());
//                 },
//                 child: Text('Month'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   await _showFinancialChart(context, calculateFinancialData_Year());
//                 },
//                 child: Text('Year'),
//               ),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//         ],
//
//       );
//     },
//   );
// }
// Future<List<FinancialPieChartItem>> calculateFinancialData() async {
//   List<FinancialPieChartItem> financialData = [];
//   try {
//
//     List<Map<String, dynamic>> result = await DatabaseManagement.instance.rawQuery(
//       'SELECT ID_type_transaction, SUM(amount_transaction) AS total_amount_Pie '
//           'FROM Transactions '
//           'WHERE type_expense = 1 '
//           'GROUP BY ID_type_transaction',
//     );
//     print('Result from database query: $result');
//     financialData = result.map((row) {
//       int id = row['ID_type_transaction'];
//       String type = row['type_transaction'];
//       double totalAmount = double.tryParse(row['total_amount_Pie'].toString()) ?? 0.0;
//       return FinancialPieChartItem(
//         id: id,
//         type: type,
//         amount: totalAmount,
//         color: getRandomColor(),
//       );
//     }).toList();
//     print('Financial data for pie chart: $financialData');
//   } catch (error) {
//     print('Error calculating financial data: $error');
//   }
//   return financialData;
// }
// Future<List<FinancialPieChartItem>> calculateFinancialData_Day() async {
//   List<FinancialPieChartItem> financialData = [];
//   try {
//     String query = '''
//       SELECT Transactions.ID_type_transaction, SUM(Transactions.amount_transaction) AS total_amount_Pie, Type_transaction.type_transaction
//       FROM Transactions
//       JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
//       WHERE Transactions.type_expense = 1 AND DATE(Transactions.date_user) = DATE("now")
//       GROUP BY Transactions.ID_type_transaction
//     ''';
//
//     List<Map<String, dynamic>> result = await DatabaseManagement.instance.rawQuery(query);
//
//     print('Result from database query: $result');
//     financialData = result.map((row) {
//       int id = row['ID_type_transaction'];
//       String type = row['type_transaction']; // ดึงประเภทของธุรกรรม
//       double totalAmount = double.tryParse(row['total_amount_Pie'].toString()) ?? 0.0;
//       return FinancialPieChartItem(
//         id: id,
//         type: type,
//         amount: totalAmount,
//         color: getRandomColor(),
//       );
//     }).toList();
//
//     print('Financial data for pie chart: $financialData');
//   } catch (error) {
//     print('Error calculating financial data: $error');
//   }
//   return financialData;
// }
//
//
// Future<List<FinancialPieChartItem>> calculateFinancialData_Month() async {
//   List<FinancialPieChartItem> financialData = [];
//   try {
//     String query = '''
//       SELECT Transactions.ID_type_transaction, SUM(Transactions.amount_transaction) AS total_amount_Pie, Type_transaction.type_transaction
//       FROM Transactions
//       JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
//       WHERE Transactions.type_expense = 1
//       AND strftime('%Y-%m', Transactions.date_user) = strftime('%Y-%m', 'now')
//       GROUP BY Transactions.ID_type_transaction
//     ''';
//
//     List<Map<String, dynamic>> result = await DatabaseManagement.instance.rawQuery(query);
//
//     print('Result from database query: $result');
//     financialData = result.map((row) {
//       int id = row['ID_type_transaction'];
//       String type = row['type_transaction'];
//       double totalAmount = double.tryParse(row['total_amount_Pie'].toString()) ?? 0.0;
//       return FinancialPieChartItem(
//         id: id,
//         amount: totalAmount,
//         type: type,
//         color: getRandomColor(),
//       );
//     }).toList();
//     print('Financial data for pie chart: $financialData');
//   } catch (error) {
//     print('Error calculating financial data: $error');
//   }
//   return financialData;
// }
//
// Future<List<FinancialPieChartItem>> calculateFinancialData_Year() async {
//   List<FinancialPieChartItem> financialData = [];
//   try {
//     String query = '''
//       SELECT Transactions.ID_type_transaction, SUM(Transactions.amount_transaction) AS total_amount_Pie, Type_transaction.type_transaction
//       FROM Transactions
//       JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
//       WHERE Transactions.type_expense = 1
//       AND strftime('%Y', Transactions.date_user) = strftime('%Y', 'now')
//       GROUP BY Transactions.ID_type_transaction
//     ''';
//
//     List<Map<String, dynamic>> result = await DatabaseManagement.instance.rawQuery(query);
//
//     print('Result from database query: $result');
//     financialData = result.map((row) {
//       int id = row['ID_type_transaction'];
//       String type = row['type_transaction'];
//       double totalAmount = double.tryParse(row['total_amount_Pie'].toString()) ?? 0.0;
//       return FinancialPieChartItem(
//         id: id,
//         type:type,
//         amount: totalAmount,
//         color: getRandomColor(),
//       );
//     }).toList();
//     print('Financial data for pie chart: $financialData');
//   } catch (error) {
//     print('Error calculating financial data: $error');
//   }
//   return financialData;
// }
//
//
//
// Future<void> _showFinancialChart(BuildContext context, Future<List<FinancialPieChartItem>> future) async {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return FutureBuilder(
//         future: future,
//         builder: (BuildContext context, AsyncSnapshot<List<FinancialPieChartItem>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             List<FinancialPieChartItem> pieChartItems = snapshot.data ?? [];
//             return AlertDialog(
//               title: Text('Financial Pie Chart'),
//               content: Container(
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 child: Center(
//                   child: FinancialPieChart(items: pieChartItems),
//                 ),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Close'),
//                 ),
//               ],
//             );
//           }
//         },
//       );
//     },
//   );
// }
//
//
// class FinancialPieChart extends StatelessWidget {
//   final List<FinancialPieChartItem> items;
//
//   FinancialPieChart({required this.items});
//
//   @override
//   Widget build(BuildContext context) {
//     double totalAmount = items.fold(0, (previous, current) => previous + current.amount);
//
//     return Row(
//       children: [
//         Expanded(
//           child: PieChart(
//             PieChartData(
//               sections: List.generate(
//                 items.length,
//                     (index) => PieChartSectionData(
//                   color: items[index].color,
//                   value: (items[index].amount / totalAmount) * 100,
//                   title: '${((items[index].amount / totalAmount) * 100).toStringAsFixed(2)}%',
//                   radius: 50,
//                   titleStyle: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               sectionsSpace: 0,
//               centerSpaceRadius: 20,
//             ),
//           ),
//         ),
//         SizedBox(width: 10), // Distance between the chart and the legend
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: List.generate(
//             items.length,
//                 (index) => Row(
//               children: [
//                 Container(
//                   width: 20,
//                   height: 20,
//                   color: items[index].color,
//                 ),
//                 SizedBox(width: 5), // Distance between color box and text
//                 Text(' ${items[index].type} \n${items[index].amount}฿'), // Expense category name
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// Color getRandomColor() {
//   final Random random = Random();
//   return Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
// }
//
// // คลาสสำหรับเก็บข้อมูลของแต่ละรายการที่จะใช้ในแผนภูมิรูปpiechart
// class FinancialPieChartItem {
//   final int id;
//   final String type;
//   final double amount;
//   final Color color;
//
//   FinancialPieChartItem({required this.id,required this.type, required this.amount, required this.color});
// }
//
// // คลาสสำหรับ Bar Chart
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         barGroups: [
//           BarChartGroupData(
//             x: 0,
//             barRods: [
//               BarChartRodData(
//                 y: totalIncome,
//                 colors: [Colors.green],
//                 width: 25,
//               ),
//             ],
//           ),
//           BarChartGroupData(
//             x: 1,
//             barRods: [
//               BarChartRodData(
//                 y: totalExpense,
//                 colors: [Colors.red],
//                 width: 25,
//               ),
//             ],
//           ),
//         ],
//         titlesData: FlTitlesData(
//           bottomTitles: SideTitles(
//             showTitles: true,
//             getTitles: (double value) {
//               if (value == 0) {
//                 return 'Income';
//               } else if (value == 1) {
//                 return 'Expense';
//               }
//               return '';
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
// Future<List<Map<String, dynamic>>> fetchAllExpenses() async {
//   try {
//     return await DatabaseManagement.instance.rawQuery('SELECT * FROM transactions WHERE type_expense = 1');
//   } catch (error) {
//     print('Error fetching expenses: $error');
//     return [];
//   }
// }
//
// // void _showStatusExpense(BuildContext context) {
// //   showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //         title: Text('Select Time Range'),
// //         content: SingleChildScrollView(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               ElevatedButton(
// //                 onPressed: () {
// //
// //                 },
// //                 child: Text('Day'),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () {
// //
// //                 },
// //                 child: Text('Month'),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () {
// //
// //                 },
// //                 child: Text('Year'),
// //               ),
// //             ],
// //           ),
// //         ),
// //         actions: <Widget>[
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //             },
// //             child: Text('Cancel'),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }
//
// //
// //***************************************** เ ก่ า*************************
// Future<List<Map<String, dynamic>>> fetchAllExpensesToday() async {
//   try {
//     return await DatabaseManagement.instance.rawQuery('SELECT * FROM transactions WHERE type_expense = 1 AND DATE(date_user) = DATE("now")');
//   } catch (error) {
//     print('Error fetching today\'s expenses: $error');
//     return [];
//   }
// }
//
// Future<List<Map<String, dynamic>>> fetchAllExpensesMonth() async {
//   try {
//     return await DatabaseManagement.instance.rawQuery('SELECT * FROM transactions WHERE type_expense = 1 AND strftime("%m", date_user) = strftime("%m", "now") AND strftime("%Y", date_user) = strftime("%Y", "now")');
//   } catch (error) {
//     print('Error fetching this month\'s expenses: $error');
//     return [];
//   }
// }
//
// Future<List<Map<String, dynamic>>> fetchAllExpensesYear() async {
//   try {
//     return await DatabaseManagement.instance.rawQuery('SELECT * FROM transactions WHERE type_expense = 1 AND strftime("%Y", date_user) = strftime("%Y", "now")');
//   } catch (error) {
//     print('Error fetching this year\'s expenses: $error');
//     return [];
//   }
// }
// //
// //
// // void _showStatus_Expense(BuildContext context) {
// //   showDialog(
// //
// //     context: context,
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //         title: Text('Select Time Range'),
// //
// //         content: SingleChildScrollView(
// //
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   Navigator.pop(context);
// //                   fetchAllExpensesToday()
// //                 },
// //                 child: Text('Day'),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   Navigator.pop(context);
// //                   fetchAllExpensesMonth()
// //                 },
// //                 child: Text('Month'),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   Navigator.pop(context);
// //                   fetchAllExpensesYear();
// //                 },
// //                 child: Text('Year'),
// //               ),
// //             ],
// //           ),
// //         ),
// //         actions: <Widget>[
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //             },
// //             child: Text('Cancel'),
// //           ),
// //         ],
// //
// //       );
// //     },
// //   );
// // }
// //*********************************** เ ก่ า ***********
//
// void _showStatus_Expense(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Select Time Range'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   Navigator.pop(context); // ปิด dialog ก่อน
//                   List<Map<String, dynamic>> expenses = await fetchAllExpensesToday();
//                   _showExpensesResult(context, expenses); // แสดงผล
//                 },
//                 child: Text('Day'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   Navigator.pop(context); // ปิด dialog ก่อน
//                   List<Map<String, dynamic>> expenses = await fetchAllExpensesMonth();
//                   _showExpensesResult(context, expenses); // แสดงผล
//                 },
//                 child: Text('Month'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   Navigator.pop(context); // ปิด dialog ก่อน
//                   List<Map<String, dynamic>> expenses = await fetchAllExpensesYear();
//                   _showExpensesResult(context, expenses); // แสดงผล
//                 },
//                 child: Text('Year'),
//               ),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//         ],
//       );
//     },
//   );
// }
//
// void _showExpensesResult(BuildContext context, List<Map<String, dynamic>> expenses) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Expenses Result'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: expenses.map((expense) {
//               return ListTile(
//                 title: Text('จำนวนเงิน: ${expense['amount_transaction']}฿'),
//                 subtitle: Text('วันที่: ${expense['date_user']}'),
//
//               );
//             }).toList(),
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }
//
//
// void _showStatusExpense2(BuildContext context) async {
//   List<Map<String, dynamic>> expenses = await fetchAllExpenses();
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('รายจ่ายทั้งหมด'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: expenses.map((expense) {
//               return ListTile(
//                 title: Text('จำนวนเงิน: ${expense['amount_transaction']}฿'),
//                 subtitle: Text('วันที่: ${expense['date_user']}'),
//               );
//             }).toList(),
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('ปิด'),
//           ),
//         ],
//       );
//     },
//   );
// }
//
//
//
// // Page2 Widget
// class Page2 extends StatelessWidget {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) =>
//       Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(title: Text('Static Chart')),
//         body: Center(
//           child: Column(
//             children: [
//               TableCalendar(
//                 firstDay: DateTime.utc(2023, 1, 1),
//                 lastDay: DateTime.utc(2024, 12, 31),
//                 focusedDay: DateTime.now(),
//               ),
//               SizedBox(height: 20),
//               SingleChildScrollView( // เพิ่ม SingleChildScrollView ที่นี่
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black, width: 2),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: IconButton(
//                         icon: Icon(Icons.pie_chart),
//                         onPressed: () async {
//                           _showFinancialPieChart(context);
//                         },
//                         iconSize: 60,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black, width: 2),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: IconButton(
//                         icon: Icon(Icons.shopify_rounded),
//                         onPressed: () {
//
//                           _showStatus_Expense(context);
//                         },
//                         iconSize: 60,
//                         color: Colors.green,
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black, width: 2),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: IconButton(
//                         icon: Icon(Icons.bar_chart),
//                         onPressed: () {
//                           _showFinancialBarChart(context); // แก้ไขตรงนี้เพื่อเรียกฟังก์ชันใหม่
//                         },
//                         iconSize: 60,
//                         color: Colors.orange,
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
// }