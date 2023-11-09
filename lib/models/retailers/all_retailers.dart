import 'package:nefos/models/retailers/retailer.dart';

class AllRetailers {
  AllRetailers({required this.retailers})
      : mappedRetailers = retailers
            .map((retailer) => Retailer(
                  id: retailer['ID'],
                  name: retailer['NAME'],
                  walletId: retailer['WALLET_ID'],
                  password: retailer['PASSWORD'],
                  balance: retailer['BALANCE'],
                  phone: retailer['PHONE_NUMBER'],
                ))
            .toList();

  final List<Map<String, dynamic>> retailers;
  final List<Retailer> mappedRetailers;
}
