import 'package:flutter/material.dart';
import 'package:nefos/models/students/student.dart';
import 'package:nefos/models/transactions/transaction.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class TransactionItem extends StatelessWidget {
  const TransactionItem(this.transaction, this.student, {super.key});

  final Transaction transaction;
  final Student student;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('From: '),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(student.name),
                    ],
                  ),
                ),
                // const SizedBox(
                //   width: 30,
                // ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('To: '),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(transaction.retailerId),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('Amount: '),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '\$${transaction.credits.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
                // const SizedBox(
                //   width: 30,
                // ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.calendar_month,
                      ),
                      Text(
                        formatter.format(transaction.timestamp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
