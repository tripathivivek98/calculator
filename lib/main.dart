import 'package:calculator/screens/calculator_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        // Define the default font family
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}
