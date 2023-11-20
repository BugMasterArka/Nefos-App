import 'package:flutter/material.dart';
import 'package:nefos/card_menu.dart';
import 'package:nefos/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        checkLoginStatus();
      });
    });
  }

  void checkLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('user') != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget landingWidget = const LoginScreen();

    if (isLoggedIn) {
      landingWidget = const CardMenu();
    }

    return landingWidget;
  }
}
