class Student {
  Student({
    required this.name,
    required this.regnNo,
    required this.walletId,
    required this.balance,
    required this.phone,
    required this.password,
    required this.pin,
    required this.status,
    required this.otp,
  });

  factory Student.fromJson(Map<String, dynamic> parsedJson) {
    return Student(
      name: parsedJson['NAME'] as String,
      regnNo: parsedJson['REG_NO'] as String,
      walletId: parsedJson['WALLET_ID'] as String,
      balance: parsedJson['BALANCE'] as int,
      phone: parsedJson['PHONE_NO'] as String,
      password: parsedJson['PASSWORD'] as String,
      pin: parsedJson['PIN'] as int,
      status: parsedJson['STATUS'] as String,
      otp: parsedJson['OTP'] as int,
    );
  }

  factory Student.fromJson2(Map<String, dynamic> parsedJson){
    return Student(
      name: parsedJson['NAME'] as String,
      regnNo: parsedJson['REG_NO'] as String,
      walletId: '',
      balance: 0,
      phone: '',
      password: '',
      pin: 0,
      status: 'false',
      otp: 0,
    );
  }

  String name;
  String regnNo;
  String walletId;
  int balance;
  String phone;
  String password;
  int pin;
  String status;
  int otp;
}
