import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nefos/card_menu.dart';
import 'package:nefos/models/students/student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _regnController = TextEditingController();
  final _otpController = TextEditingController();
  @override
  void dispose() {
    _regnController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<Student?> loginCheck(String regnNumber, int otp) async {
    await Future.delayed(const Duration(seconds: 1));
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('user') != null) {
      final fetchedJson = jsonDecode(pref.getString('user')!);
      return Student.fromJson2(fetchedJson);
    } else {
      Student? student;
      Map<String, dynamic> request = {
        "reg_no": regnNumber
      };

      // ? request needs to accept this 2 things as body (regn number and OTP)

      final url = Uri.parse('http://10.0.2.2:7000/student/login');
      final response = await http.post(url, body: request);

      if ((response.statusCode != 200 || response.body.isEmpty) &&
          context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect Credentials'),
            duration: Duration(seconds: 1),
          ),
        );
        return student;
      }

      Map<String, dynamic> parsedJson = jsonDecode(response.body)[0];

      int? fetchedOtp = parsedJson['OTP'] as int;
      String? fetchedRegn = parsedJson['REG_NO'] as String;

      if ((regnNumber != fetchedRegn || otp != fetchedOtp) && context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect Credentials'),
            duration: Duration(seconds: 1),
          ),
        );
        return student;
      }

      student = Student.fromJson(parsedJson);

      String user = jsonEncode(parsedJson);

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('user', user);

      return student;
    }
  }

  void _onSubmitLoginForm() async {
    // * regn number
    String regnNumber = _regnController.text.trim();
    const regnRegexPattern = r'^\d{2}[a-zA-Z]{3}\d{4}$';
    final regnRegex = RegExp(regnRegexPattern);

    // * otp
    String otpText = _otpController.text;
    const otpRegexPattern = r'\d{4}';
    final otpRegex = RegExp(otpRegexPattern);
    int? otp = int.tryParse(otpText);

    if ((!regnRegex.hasMatch(regnNumber) ||
            !otpRegex.hasMatch(otpText) ||
            otp == null) &&
        context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Input'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // * OTP and user details will be fetched from api

    Student? student = await loginCheck(regnNumber, otp!);

    if (student != null && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const CardMenu(),
        ),
      );
    }
  }

  // ! test function for login
  void _testLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    Map<String, dynamic> json = [{
      "id": "oqhdoqd",
      "name": "Arka Lodh",
      "reg_no": "20BCE7349",
      "wallet_id": "ceocucqoeqyo39729383t2vkq3gdiqugd31i2dggkjg2o3u",
      "balance": 1238.00,
      "phone_no": "8101902952",
      "password": "skdecwue8ceciihqwco2ich2oh3h3l2lkenlsdccsod8cyaa",
      "pin": 1234,
      "status": true,
      "otp": null
    }][0];

    await pref.setString('user', jsonEncode(json));
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const CardMenu(),
        ),
      );
    }
  }

  // ! test function 2 for login
  void _testLogin2() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const CardMenu(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // var keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(255, 236, 131, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/login-logo-3.png',
                width: 300,
              ),
              Text(
                'Nefos',
                style: GoogleFonts.bebasNeue(
                  color: const Color.fromARGB(255, 121, 188, 197),
                  fontSize: 36,
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                width: 300,
                // padding: EdgeInsets.only(bottom: keyboardSpace+16),
                child: Column(
                  children: [
                    TextField(
                      maxLength: 9,
                      controller: _regnController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 20,
                        ),
                        label: Text('Registration Number: 20BCEXXXX'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      maxLength: 4,
                      controller: _otpController,
                      decoration: const InputDecoration(
                        label: Text('4 digit OTP here'),
                        contentPadding: EdgeInsets.only(
                          left: 20,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      // ! change login to original function
                      onPressed: _onSubmitLoginForm,
                      icon: const Icon(Icons.arrow_right_alt),
                      label: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
