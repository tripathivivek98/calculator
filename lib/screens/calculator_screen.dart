import 'package:flutter/material.dart';

import '../utils/calculator_logic.dart';
import '../widgets/calculator_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Initialize the domain logic/state manager
  late final CalculatorLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = CalculatorLogic();
    // Listen for changes and rebuild the UI
    _logic.addListener(_rebuildUI);
  }

  @override
  void dispose() {
    _logic.removeListener(_rebuildUI);
    _logic.dispose();
    super.dispose();
  }

  // Simple method to force a rebuild when CalculatorLogic notifies listeners
  void _rebuildUI() {
    setState(() {});
  }

  // Define the layout of the buttons. Replaced one '=' with '⌫'.
  final List<List<String>> buttonLayout = const [
    ['C', '/', 'x', '%'],
    ['7', '8', '9', '-'],
    ['4', '5', '6', '+'],
    ['1', '2', '3', '⌫'], // Backspace button added here
    ['0', '.','='], // Last row: '0'(2 units), '.'(1 unit), '='(1 unit). The '' is a placeholder to align the row.
  ];

  /// Get color for a button based on its text.
  Color _getButtonColor(String text) {
    // '⌫' uses the utility color (BlueGrey)
    if (text == 'C' || text == '%' || text == '⌫') return Colors.blueGrey.shade700;
    if (['/', 'x', '-', '+', '='].contains(text)) {
      return Colors.orange.shade700;
    }
    return const Color(0xFF3B3B3B); // Dark grey for numbers/dot
  }

  /// Get text color for a button.
  Color _getButtonTextColor(String text) {
    if (text == 'C' || text == '%' || text == '⌫') return Colors.white;
    if (['/', 'x', '-', '+', '='].contains(text)) return Colors.white;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    // Get the size for responsiveness, primarily for text sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final displayFontSize = screenWidth * 0.16;
    final historyFontSize = screenWidth * 0.07;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Very dark background
      appBar: AppBar(
        title: const Text('Calculator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // --- Display Area ---
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // History Display
                    Text(
                      _logic.displayHistory,
                      style: TextStyle(
                        fontSize: historyFontSize,
                        color: Colors.white70,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Main Buffer/Result Display
                    Text(
                      _logic.hasError ? 'Error' : _logic.displayBuffer,
                      style: TextStyle(
                        fontSize: displayFontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // --- Button Grid ---
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: buttonLayout.map((row) {
                  return Row(
                    children: row.map((buttonText) {
                      // if (buttonText.isEmpty) {
                      //   // Empty slot in the last row is ignored (or can be a Spacer)
                      //   // A Spacer ensures the preceding buttons fill the available space evenly.
                      //   return const Spacer();
                      // }

                      // Determine flex. '0' is 2x wide, all others are 1x.
                      int flex = 1;
                      if (buttonText == '=' || buttonText == '0') {
                        flex = 2;
                      }

                      return CalculatorButton(
                        text: buttonText,
                        color: _getButtonColor(buttonText),
                        textColor: _getButtonTextColor(buttonText),
                        onTap: () => _logic.buttonPressed(buttonText),
                        flex: flex,
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}