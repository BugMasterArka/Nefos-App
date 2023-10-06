class Transaction {
  Transaction({
    required this.transactionId,
    required this.studentId,
    required this.retailerId,
    required this.credits,
    required this.timestamp,
  });
  String transactionId;
  String studentId;
  String retailerId;
  double credits;
  DateTime timestamp;
}
