import 'package:nefos/models/retailers/retailer.dart';

class AllRetailers {
  AllRetailers({required this.retailers})
      : mappedRetailers = retailers
            .map((retailer) => Retailer(
                  id: retailer['id'],
                  name: retailer['name'],
                  walletId: retailer['wallet_id'],
                  password: retailer['password'],
                  balance: retailer['balance'],
                  phone: retailer['phone_number'],
                ))
            .toList();

  final List<Map<String, dynamic>> retailers;
  final List<Retailer> mappedRetailers;
}
