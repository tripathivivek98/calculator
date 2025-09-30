import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final int flex;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.color,
    this.textColor = Colors.white,
    required this.onTap,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            textStyle: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
            elevation: 8,
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
