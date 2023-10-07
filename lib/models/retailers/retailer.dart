class Retailer {
  const Retailer({
    required this.id,
    required this.name,
    required this.walletId,
    required this.password,
    required this.balance,
    required this.phone
  });

  final String name;
  final String id;
  final String walletId;
  final double balance;
  final String phone;
  final String password;
}
