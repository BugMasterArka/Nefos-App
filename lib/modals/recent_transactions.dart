import 'package:flutter/material.dart';

import 'package:nefos/data/dummy_json.dart';
import 'package:nefos/models/students/all_students.dart';
import 'package:nefos/models/transactions/all_transactions.dart';
import 'package:nefos/models/students/student.dart';
import 'package:nefos/models/transactions/transaction.dart';
import 'package:nefos/widgets/transaction_item.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() {
    return _RecentTransactionsState();
  }
}

class _RecentTransactionsState extends State<RecentTransactions> {
  final List<Transaction> _recentTransactions =
      AllTransactions(transactions: registeredTransactions).mappedTransactions;

  final List<Student> _students =
      AllStudents(students: registeredPeople).mappedStudents;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: _recentTransactions.length,
        itemBuilder: (ctx, index) {
          return TransactionItem(_recentTransactions[index],_students.where((student) => _recentTransactions[index].studentId==student.id).toList()[0]);
        },
      ),
    );
  }
}
