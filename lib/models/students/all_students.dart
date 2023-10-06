import 'package:nefos/models/students/student.dart';

class AllStudents {
  AllStudents({required this.students})
      : mappedStudents = students
            .map(
              (student) => Student(
                  id: student['id'],
                  name: student['name'],
                  regnNo: student['reg_no'] as String,
                  walletId: student['wallet_id'],
                  balance: student['balance'] as double,
                  phone: student['phone_no'] as String,
                  password: student['password'] as String,
                  pin: student['pin'] as int,
                  status: student['status'] as bool),
            )
            .toList();

  final List<Map<String, dynamic>> students;
  final List<Student> mappedStudents;
}
