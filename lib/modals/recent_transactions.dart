import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nefos/models/retailers/all_retailers.dart';

// import 'package:nefos/data/dummy_json.dart';
// import 'package:nefos/models/students/all_students.dart';
import 'package:nefos/models/transactions/all_transactions.dart';
import 'package:nefos/models/students/student.dart';
import 'package:nefos/models/transactions/transaction.dart';
import 'package:nefos/models/retailers/retailer.dart';
import 'package:nefos/widgets/transaction_item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() {
    return _RecentTransactionsState();
  }
}

class _RecentTransactionsState extends State<RecentTransactions> {
  bool _loading = true;
  List<Transaction>? _recentTransactions;
  Student? _student;
  List<Retailer>? _retailers;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _initializePage();
      });
    });
  }

  void _showSnackBar(String content) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(content),
        ),
      );
    }
  }

  void _initializePage() async {
    _student = await _fetchStudent();
    if (_student == null) {
      _showSnackBar('Unable to fetch Student');
      return;
    }
    print('student fetched');
    _recentTransactions = await _fetchTransactions(_student!.regnNo);
    if (_recentTransactions == null) {
      _showSnackBar('Unable to fetch Transactions');
      return;
    }
    print('transactions fetched');
    _retailers = await _fetchRetailers();
    if (_retailers == null) {
      _showSnackBar('Unable to fetch retailers');
    }
    print('retailers fetched');
    setState(() {
      _loading = false;
    });
  }

  Future<Student?> _fetchStudent() async {
    await Future.delayed(const Duration(seconds: 1));

    Student? student;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('user') == null && context.mounted) {
      Navigator.pop(context);
      return student;
    }

    student = Student.fromJson2(jsonDecode(pref.getString('user')!));
    return student;
  }

  Future<List<Transaction>?> _fetchTransactions(String regNo) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Transaction>? transactions;
    // Student? student;

    // SharedPreferences pref = await SharedPreferences.getInstance();
    // if (pref.getString('user') == null && context.mounted) {
    //   return transactions;
    // }

    // student = Student.fromJson2(jsonDecode(pref.getString('user')!));

    // Map<String, dynamic> request = {"reg_no": student.regnNo};

    Map<String, dynamic> request = {"reg_no": regNo};

    try {
      print('transaction 1');
      final url = Uri.parse('http://10.0.2.2:7000/student/studentInfo');

      final response = await http.post(url, body: request);

      if ((response.statusCode != 200 || response.body.isEmpty) &&
          context.mounted) {
        print('transaction error 1 ');
        Navigator.of(context).pop();
        return transactions;
      }
      print(response.body);
      transactions = AllTransactions(
              transactions: (jsonDecode(response.body) as List)
                  .cast<Map<String, dynamic>>())
          .mappedTransactions;
      return transactions;
    } catch (e) {
      print('transaction error 2');
      print(e);
      if (context.mounted) {
        Navigator.pop(context);
      }
      return null;
    }
  }

  Future<List<Retailer>?> _fetchRetailers() async {
    List<Retailer>? retailers;
    try {
      print('retailer 1');
      final url = Uri.parse('http://10.0.2.2:7000/student/retailerInfo');

      final response = await http.post(url);

      print('retailer 2');
      if ((response.statusCode != 200 || response.body.isEmpty) &&
          context.mounted) {
        print('retailer error 1');
        Navigator.pop(context);
        return retailers;
      }

      retailers = AllRetailers(
              retailers: (jsonDecode(response.body) as List)
                  .cast<Map<String, dynamic>>())
          .mappedRetailers;

      return retailers;
    } catch (e) {
      print('retailer error 2');
      print(e);
      if (context.mounted) {
        Navigator.of(context);
      }
      return null;
    }
  }

  // // * registeredTransactions must be fetched using HTTPS requests
  // final List<Transaction> _recentTransactions =
  //     AllTransactions(transactions: registeredTransactions).mappedTransactions;

  // // * registeredPeople must be fetched using HTTPS requests
  // final List<Student> _students =
  //     AllStudents(students: registeredPeople).mappedStudents;

  // // * registeredRetailers must be fetched using HTTPS requests
  // final List<Retailer> _retailers =
  //     AllRetailers(retailers: registeredRetailers).mappedRetailers;

  Widget noTransactions = Center(
    child: Column(
      children: [
        Image.asset(
          'assets/images/no-transactions.png',
          width: 200,
        ),
        const SizedBox(
          height: 30,
        ),
        const Text('Uh oh... No Transactions Yet'),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    Widget activeWidget = const SpinKitRotatingCircle(
      color: Color.fromARGB(255, 83, 83, 83),
      size: 50.0,
    );

    if (!_loading) {
      if (_recentTransactions!.isEmpty) {
        activeWidget = noTransactions;
      } else {
        activeWidget = ListView.builder(
          itemCount: _recentTransactions!.length,
          itemBuilder: (ctx, index) {
            return TransactionItem(
              _recentTransactions![index],
              _student!,
              _retailers!
                  .where((retailer) =>
                      _recentTransactions![index].retailerId == retailer.id)
                  .toList()[0],
            );
          },
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: activeWidget,
    );
  }
}
