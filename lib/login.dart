import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nefos/card_menu.dart';

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
    super.dispose();
  }

  _onSubmitLoginForm() {
    String regnNumber = _regnController.text.trim();
    const regnRegexPattern = r'^\d{2}[a-zA-Z]{3}\d{4}$';
    final regnRegex = RegExp(regnRegexPattern);

    // * OTP and user details will be fetched from api

    int? fetchedOtp = 1234;
    String? fetchedRegn = "20BCE7349";

    String otpText = _otpController.text;
    const otpRegexPattern = r'\d{4}';
    final otpRegex = RegExp(otpRegexPattern);
    int? otp = int.tryParse(otpText);
    if (!regnRegex.hasMatch(regnNumber) ||
        !otpRegex.hasMatch(otpText) ||
        otp == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Input'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    if (regnNumber != fetchedRegn || otp != fetchedOtp) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect Credentials'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

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
