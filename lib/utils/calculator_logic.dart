import 'package:flutter/material.dart';

class CalculatorLogic extends ChangeNotifier {
  String _history = '0';
  String _buffer = '0';
  double? _operand1;
  String? _operator;
  bool _shouldClearBuffer = false;
  bool _hasError = false;

  String get displayHistory => _history;
  String get displayBuffer => _buffer;
  bool get hasError => _hasError;

  /// Resets the calculator state.
  void clear() {
    _history = '0';
    _buffer = '0';
    _operand1 = null;
    _operator = null;
    _shouldClearBuffer = false;
    _hasError = false;
    notifyListeners();
  }

  /// Handles digit and decimal point input.
  void _handleDigit(String digit) {
    if (_hasError) clear();

    if (_buffer == '0' || _shouldClearBuffer) {
      if (digit == '.') {
        _buffer = '0.';
      } else {
        _buffer = digit;
      }
      _shouldClearBuffer = false;
    } else if (digit == '.') {
      if (!_buffer.contains('.')) {
        _buffer += '.';
      }
    } else {
      _buffer += digit;
    }
    notifyListeners();
  }

  /// Handles arithmetic operator input (+, -, x, /).
  void _handleOperator(String newOperator) {
    if (_hasError) return;

    final double currentNumber = double.tryParse(_buffer) ?? 0.0;

    if (_operand1 == null) {
      // First operand
      _operand1 = currentNumber;
      _operator = newOperator;
      _history = '${_formatNumber(_operand1!)} $newOperator';
      _shouldClearBuffer = true;
    } else {
      // Subsequent operator pressed, calculate previous result first
      if (_operator != null) {
        final result = _calculate(_operand1!, currentNumber, _operator!);
        _operand1 = result;
        _operator = newOperator;
        _history = '${_formatNumber(_operand1!)} $newOperator';
        _buffer = _formatNumber(_operand1!);
        _shouldClearBuffer = true;
      } else {
        // Operator pressed after equals (=)
        _operator = newOperator;
        _history = '${_formatNumber(currentNumber)} $newOperator';
        _operand1 = currentNumber;
        _shouldClearBuffer = true;
      }
    }
    notifyListeners();
  }

  /// Handles the equals (=) button press.
  void _handleEquals() {
    if (_hasError || _operator == null) return;

    final double operand2 = double.tryParse(_buffer) ?? 0.0;
    _history = '${_formatNumber(_operand1!)} $_operator ${_formatNumber(operand2)} =';

    final result = _calculate(_operand1!, operand2, _operator!);

    _buffer = _formatNumber(result);
    _operand1 = null;
    _operator = null;
    _shouldClearBuffer = true;
    notifyListeners();
  }

  /// Handles the percentage (%) button press.
  void _handlePercentage() {
    if (_hasError) return;
    final double currentNumber = double.tryParse(_buffer) ?? 0.0;
    final result = currentNumber / 100.0;
    _buffer = _formatNumber(result);
    notifyListeners();
  }

  /// Handles the backspace (⌫) button press.
  void _handleBackspace() {
    if (_hasError) {
      clear();
      return;
    }

    if (_buffer.length > 1) {
      // Remove the last character
      _buffer = _buffer.substring(0, _buffer.length - 1);
    } else if (_buffer.length == 1 && _buffer != '0') {
      // If it's a single digit (not 0), replace with 0
      _buffer = '0';
    }
    // If _buffer is already '0', do nothing.

    _shouldClearBuffer = false; // Allow input after backspace
    notifyListeners();
  }

  /// Performs the actual arithmetic calculation.
  double _calculate(double n1, double n2, String op) {
    try {
      switch (op) {
        case '+':
          return n1 + n2;
        case '-':
          return n1 - n2;
        case 'x':
          return n1 * n2;
        case '/':
          if (n2 == 0) {
            _hasError = true;
            return double.nan; // Indicates error (Division by zero)
          }
          return n1 / n2;
        default:
          return n2;
      }
    } catch (e) {
      _hasError = true;
      return double.nan;
    }
  }

  /// Formats the number for display, removing trailing .0 if it's an integer.
  String _formatNumber(double n) {
    if (_hasError) return 'Error';

    if (n.isInfinite) return 'Overflow';

    // Check if the number is an integer
    if (n == n.roundToDouble()) {
      return n.toInt().toString();
    }
    // Limit to 8 decimal places for display
    return n.toStringAsPrecision(8);
  }

  /// Main entry point for button presses from the UI.
  void buttonPressed(String buttonText) {
    switch (buttonText) {
      case 'C':
        clear();
        break;
      case '⌫': // New case for Backspace
        _handleBackspace();
        break;
      case '=':
        _handleEquals();
        break;
      case '%':
        _handlePercentage();
        break;
      case '+':
      case '-':
      case 'x':
      case '/':
        _handleOperator(buttonText);
        break;
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
      case '.':
        _handleDigit(buttonText);
        break;
    }
  }
}
