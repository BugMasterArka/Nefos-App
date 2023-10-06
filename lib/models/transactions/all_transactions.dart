import 'package:nefos/models/transactions/transaction.dart';

class AllTransactions {
  AllTransactions({required this.transactions})
      : mappedTransactions = transactions
            .map(
              (transaction) => Transaction(
                  transactionId: transaction['t_id'] as String,
                  studentId: transaction['student_id'] as String,
                  retailerId: transaction['retailer_id'] as String,
                  credits: transaction['credits'] as double,
                  timestamp: transaction['timestamp'] as DateTime),
            )
            .toList();

  final List<Map<String, dynamic>> transactions;
  final List<Transaction> mappedTransactions;
}
