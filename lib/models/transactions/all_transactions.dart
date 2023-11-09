import 'package:nefos/models/transactions/transaction.dart';

class AllTransactions {
  AllTransactions({required this.transactions})
      : mappedTransactions = transactions
            .map(
              (transaction) => Transaction(
                transactionId: transaction['T_ID'] as String,
                studentId: transaction['STUDENT_ID'] as String,
                retailerId: transaction['RETAILER_ID'] as String,
                credits: transaction['CREDITS'] as int,
                timestamp: transaction['TIMESTAMP'] as String,
              ),
            )
            .toList();

  final List<Map<String, dynamic>> transactions;
  final List<Transaction> mappedTransactions;
}
