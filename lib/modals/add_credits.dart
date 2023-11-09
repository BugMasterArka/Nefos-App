import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nefos/models/students/student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddCredits extends StatefulWidget {
  const AddCredits({super.key});

  @override
  State<AddCredits> createState() {
    return _AddCreditsState();
  }
}

class _AddCreditsState extends State<AddCredits> {
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();
  Student? _student;

  // * uncomment for production build

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('initstate called');
      _initializeStudent();
    });
  }

  void _initializeStudent() async {
    _student = await _getStudent();
    if (_student == null && context.mounted) {
      print('here');
      // Navigator.pop(context);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Unable to Fetch Student'),
        ),
      );
      // Navigator.pop(context);
      return;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

// * in the below function the fetchedPin will be fetched from backend by HTTPS request

  Future<Student?> _getStudent() async {
    await Future.delayed(const Duration(seconds: 1));
    Student? student;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('user') == null && context.mounted) {
      print('returned');
      Navigator.of(context).pop();
      return student;
    }
    // ? should be changed to student.fromJson2 later
    student = Student.fromJson2(jsonDecode(pref.getString('user')!));

    Map<String, dynamic> request = {"reg_no": student.regnNo};

    // !create a route to get the student details (current)
    try {
      final url = Uri.parse('http://10.0.2.2:7000/student/login');
      final response = await http.post(url, body: request);

      if ((response.statusCode != 200 || response.body.isEmpty) &&
          context.mounted) {
        Navigator.of(context).pop();
        // ScaffoldMessenger.of(context).clearSnackBars();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text(
        //       'Unable to fetch student inside',
        //     ),
        //     duration: Duration(
        //       seconds: 2,
        //     ),
        //   ),
        // );
        return null;
      }
      Student fetchedStudent = Student.fromJson(jsonDecode(response.body)[0]);
      return fetchedStudent;
    } catch (e) {
      if (context.mounted) {
        print('excepted');
        Navigator.pop(context);
        // ScaffoldMessenger.of(context).clearSnackBars();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text(
        //       'No Internet',
        //     ),
        //     duration: Duration(
        //       seconds: 2,
        //     ),
        //   ),
        // );
      }
      return null;
    }
  }

  // * in the below function the credits will be added to the backend by HTTPS request

  Future<bool> _creditAddition(int amount, String regn) async {
    Map<String, dynamic> request = {"reg_no": regn, "creds": amount.toString()};

    // * this route needs to return boolean value as to whethe credits added or not

    try {
      print('added 1');

      final url = Uri.parse('http://10.0.2.2:7000/student/topup');
      final response = await http.post(url, body: request);

      print("added 2");

      if ((response.statusCode != 200 ||
              !(response.body == 'true' ? true : false)) &&
          context.mounted) {
        print('error 1');
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to add credits'),
          ),
        );
        return false;
      }
      return response.body == 'true'?true:false;
    } catch (e) {
      print('error 2');
      print(e);

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to perform request'),
          ),
        );
      }
      return false;
    }
  }

  void _onSubmitAddition() async {
    var enteredAmount = int.tryParse(_amountController.text);
    var enteredPin = int.tryParse(_pinController.text);
    // int? fetchedPin = 1234;

    if ((enteredAmount == null || enteredPin == null) && context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: Row(children: [
              Image.asset(
                'assets/images/error2.png',
                width: 100,
              ),
              const Expanded(
                child: Text('Make Sure to fill all the mandatory fields'),
              ),
            ]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
      return;
    }

    if ((enteredPin != _student!.pin) && context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Incorrect Pin'),
            content: Row(
              children: [
                Image.asset(
                  'assets/images/wrong2.png',
                  width: 100,
                ),
                const Expanded(
                  child: Text(
                    'Incorrectly Entered Pin',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay!'),
              ),
            ],
          );
        },
      );
      return;
    }

    if ((enteredPin == _student!.pin &&
            await _creditAddition(enteredAmount!, _student!.regnNo)) &&
        context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Success'),
            content: Row(
              children: [
                Image.asset(
                  'assets/images/correct2.png',
                  width: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: Text('Successfully added Credits'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    }
  }

  // ! test function for credits addition
  void _onSubmitAdditionTest() {
    var enteredAmount = double.tryParse(_amountController.text);
    var enteredPin = int.tryParse(_pinController.text);
    int? fetchedPin = 1234;

    if (enteredAmount == null || enteredPin == null) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: Row(children: [
              Image.asset(
                'assets/images/error2.png',
                width: 100,
              ),
              const Expanded(
                child: Text('Make Sure to fill all the mandatory fields'),
              ),
            ]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (enteredPin != fetchedPin) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Incorrect Pin'),
            content: Row(
              children: [
                Image.asset(
                  'assets/images/wrong2.png',
                  width: 100,
                ),
                const Expanded(
                  child: Text(
                    'Incorrectly Entered Pin',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay!'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (enteredPin == fetchedPin) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Success'),
            content: Row(
              children: [
                Image.asset(
                  'assets/images/correct2.png',
                  width: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: Text('Successfully added Credits'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: _amountController,
            decoration: const InputDecoration(
              label: Text('Credits'),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            keyboardType: TextInputType.number,
            obscureText: true,
            controller: _pinController,
            decoration: const InputDecoration(
              label: Text('Pin'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                onPressed: _onSubmitAddition,
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
