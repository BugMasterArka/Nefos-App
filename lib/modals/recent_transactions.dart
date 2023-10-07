import 'package:flutter/material.dart';
import 'package:nefos/models/retailers/all_retailers.dart';

import 'package:nefos/data/dummy_json.dart';
import 'package:nefos/models/students/all_students.dart';
import 'package:nefos/models/transactions/all_transactions.dart';
import 'package:nefos/models/students/student.dart';
import 'package:nefos/models/transactions/transaction.dart';
import 'package:nefos/models/retailers/retailer.dart';
import 'package:nefos/widgets/transaction_item.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() {
    return _RecentTransactionsState();
  }
}

class _RecentTransactionsState extends State<RecentTransactions> {

  // * registeredTransactions must be fetched using HTTPS requests
  final List<Transaction> _recentTransactions =
      AllTransactions(transactions: registeredTransactions).mappedTransactions;

  // * registeredPeople must be fetched using HTTPS requests
  final List<Student> _students =
      AllStudents(students: registeredPeople).mappedStudents;

  // * registeredRetailers must be fetched using HTTPS requests
  final List<Retailer> _retailers =
      AllRetailers(retailers: registeredRetailers).mappedRetailers;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: _recentTransactions.length,
        itemBuilder: (ctx, index) {
          return TransactionItem(
            _recentTransactions[index],
            _students
                .where((student) =>
                    _recentTransactions[index].studentId == student.id)
                .toList()[0],
            _retailers
                .where((retailer) =>
                    _recentTransactions[index].retailerId == retailer.id)
                .toList()[0],
          );
        },
      ),
    );
  }
}
