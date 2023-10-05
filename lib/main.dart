import 'package:flutter/material.dart';
import 'package:nefos/card_menu.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: const CardMenu(),
  ));
}
