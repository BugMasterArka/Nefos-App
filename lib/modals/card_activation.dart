import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nefos/models/students/student.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'dart:convert';

class CardActivation extends StatefulWidget {
  const CardActivation({super.key});

  @override
  State<CardActivation> createState() {
    return _CardActivationState();
  }
}
// * default value of activation status should be fetched from backend

class _CardActivationState extends State<CardActivation> {
  // ! commented for test purposes

  String? _activationStatus;
  String? _buttonText;
  Student? _student;
  bool loading = true;

  // ! comment below vars for actual build

  // String _activationStatus = 'true';
  // String _buttonText = 'Deactivate';

  // * uncomment for production build

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        print('initstate called');
        _initializeValues();
      });
    });
  }

  void _initializeValues() async {
    _student = await _getStudent();
    if (_student != null) {
      setState(() {
        _activationStatus = _student!.status;
        _buttonText = _activationStatus == 'TRUE' ? 'Deactivate' : 'Activate';
        loading = false;
      });
    } else if (context.mounted) {
      print('outing');
      _showSnackBar('Unable to fetch student');
    }
  }

  void _showSnackBar(String content) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(content),
        ),
      );
    }
  }

  Future<Student?> _getStudent() async {
    await Future.delayed(const Duration(seconds: 1));
    SharedPreferences pref = await SharedPreferences.getInstance();
    Student? student;
    if (pref.getString('user') == null && context.mounted) {
      print('here');
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
        Navigator.pop(context);
        // _showSnackBar('Unable to perform addition right now!');
        return null;
      }
      Student fetchedStudent = Student.fromJson(jsonDecode(response.body)[0]);
      return fetchedStudent;
    } catch (e) {
      if (context.mounted) {
        print('excepted');
        Navigator.pop(context);
        // _showSnackBar('No Internet');
      }
      return null;
    }
  }

  Future<bool> _updateStatusOnline(String regn, String status) async {
    Map<String, dynamic> request = {"reg_no": regn, "status": status};

    // ! create this route on the backend to update card status
    // * will return boolean value

    try {
      print('updating 1');
      final url = Uri.parse('http://10.0.2.2:7000/student/updateIDStat');
      final response = await http.post(url, body: request);
      print('updating 2');
      if ((response.statusCode != 200 ||
              !(response.body == 'true' ? true : false)) &&
          context.mounted) {
        print('response error');
        print(response.body);
        _showSnackBar('Unable to update status');
        return false;
      }
      print(response.body);
      return response.body == 'true' ? true : false;
    } catch (e) {
      print(e);
      if (context.mounted) {
        print('request error');
        Navigator.pop(context);
        _showSnackBar('Unable to perform request');
      }
      return false;
    }
  }

// * in the below function activation status should be updated in the backend
  void _activationPress() async {
    if (await _updateStatusOnline(_student!.regnNo, _activationStatus!)) {
      setState(() {
        _activationStatus = _activationStatus == 'true' ? 'false' : 'TRUE';
        _buttonText = _activationStatus == 'true' ? 'Deactivate' : 'Activate';
      });
    }
  }

  void _testActivationPress() {
    setState(() {
      _activationStatus = _activationStatus == 'TRUE' ? 'FALSE' : 'TRUE';
      _buttonText = _activationStatus == 'TRUE' ? 'Deactivate' : 'Activate';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeWidget = const SpinKitRotatingCircle(
      color: Color.fromARGB(255, 83, 83, 83),
      size: 50.0,
    );

    if (!loading) {
      activeWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Current Status: ',
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                _activationStatus.toString(),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _activationPress,
            child: Text(
              _buttonText!,
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: activeWidget,
    );
  }
}
