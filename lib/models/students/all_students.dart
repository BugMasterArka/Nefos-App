import 'package:nefos/models/students/student.dart';

class AllStudents {
  AllStudents({required this.students})
      : mappedStudents = students
            .map(
              (student) => Student(
                  name: student['NAME'],
                  regnNo: student['REG_NO'] as String,
                  walletId: student['WALLET_ID'],
                  balance: student['BALANCE'] as int,
                  phone: student['PHONE_NO'] as String,
                  password: student['PASSWORD'] as String,
                  pin: student['PIN'] as int,
                  status: student['STATUS'] as String,
                  otp: student['OTP'] as int),
            )
            .toList();

  final List<Map<String, dynamic>> students;
  final List<Student> mappedStudents;
  Student? student;
}
