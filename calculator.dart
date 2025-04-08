import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentNumber = "";
  String _operation = "";
  double _firstNumber = 0;
  double _secondNumber = 0;
  bool _isOperationSelected = false;

  void _onButtonPressed(String buttonText) {
    if (buttonText == "C") {
      _clear();
      return;
    }

    if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "×" ||
        buttonText == "÷") {
      _handleOperation(buttonText);
      return;
    }

    if (buttonText == "=") {
      _calculateResult();
      return;
    }

    if (buttonText == "⌫") {
      _handleBackspace();
      return;
    }

    if (buttonText == ".") {
      _handleDecimalPoint();
      return;
    }

    _handleNumber(buttonText);
  }

  void _clear() {
    setState(() {
      _output = "0";
      _currentNumber = "";
      _operation = "";
      _firstNumber = 0;
      _secondNumber = 0;
      _isOperationSelected = false;
    });
  }

  void _handleOperation(String op) {
    if (_currentNumber.isNotEmpty) {
      _firstNumber = double.parse(_currentNumber);
      _currentNumber = "";
      _operation = op;
      _isOperationSelected = true;
      setState(() {
        _output =
            _firstNumber.toString().endsWith(".0")
                ? _firstNumber.toInt().toString()
                : _firstNumber.toString();
      });
    } else if (_output != "0" && !_isOperationSelected) {
      _firstNumber = double.parse(_output);
      _operation = op;
      _isOperationSelected = true;
    } else {
      // Change operation if one is already selected
      _operation = op;
    }
  }

  void _calculateResult() {
    if (_currentNumber.isNotEmpty && _operation.isNotEmpty) {
      _secondNumber = double.parse(_currentNumber);
      double result = 0;

      switch (_operation) {
        case "+":
          result = _firstNumber + _secondNumber;
          break;
        case "-":
          result = _firstNumber - _secondNumber;
          break;
        case "×":
          result = _firstNumber * _secondNumber;
          break;
        case "÷":
          if (_secondNumber != 0) {
            result = _firstNumber / _secondNumber;
          } else {
            setState(() {
              _output = "Error";
            });
            return;
          }
          break;
      }

      setState(() {
        // Format result to remove decimal part if it's a whole number
        _output =
            result.toString().endsWith(".0")
                ? result.toInt().toString()
                : result.toString();
        _currentNumber = _output;
        _operation = "";
        _isOperationSelected = false;
      });
    }
  }

  void _handleBackspace() {
    if (_currentNumber.isNotEmpty) {
      setState(() {
        _currentNumber = _currentNumber.substring(0, _currentNumber.length - 1);
        _output = _currentNumber.isEmpty ? "0" : _currentNumber;
      });
    }
  }

  void _handleDecimalPoint() {
    if (_isOperationSelected && _currentNumber.isEmpty) {
      setState(() {
        _currentNumber = "0.";
        _output = _currentNumber;
      });
    } else if (!_currentNumber.contains(".")) {
      setState(() {
        _currentNumber += ".";
        _output = _currentNumber;
      });
    }
  }

  void _handleNumber(String number) {
    if (_isOperationSelected && _currentNumber.isEmpty) {
      setState(() {
        _currentNumber = number;
        _output = _currentNumber;
      });
    } else {
      // Replace the initial "0" with the number
      if (_currentNumber == "0" && number != ".") {
        _currentNumber = number;
      } else {
        _currentNumber += number;
      }
      setState(() {
        _output = _currentNumber;
      });
    }
  }

  Widget _buildButton(String buttonText, Color buttonColor, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24.0,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator'), centerTitle: true),
      body: Column(
        children: [
          // Display
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Operation indicator
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerRight,
            child: Text(
              _operation,
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          // Buttons
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Row 1
                  Row(
                    children: [
                      _buildButton("C", Colors.redAccent, Colors.white),
                      _buildButton("⌫", Colors.grey, Colors.white),
                      _buildButton("÷", Colors.orange, Colors.white),
                    ],
                  ),
                  // Row 2
                  Row(
                    children: [
                      _buildButton("7", Colors.grey[300]!, Colors.black),
                      _buildButton("8", Colors.grey[300]!, Colors.black),
                      _buildButton("9", Colors.grey[300]!, Colors.black),
                      _buildButton("×", Colors.orange, Colors.white),
                    ],
                  ),
                  // Row 3
                  Row(
                    children: [
                      _buildButton("4", Colors.grey[300]!, Colors.black),
                      _buildButton("5", Colors.grey[300]!, Colors.black),
                      _buildButton("6", Colors.grey[300]!, Colors.black),
                      _buildButton("-", Colors.orange, Colors.white),
                    ],
                  ),
                  // Row 4
                  Row(
                    children: [
                      _buildButton("1", Colors.grey[300]!, Colors.black),
                      _buildButton("2", Colors.grey[300]!, Colors.black),
                      _buildButton("3", Colors.grey[300]!, Colors.black),
                      _buildButton("+", Colors.orange, Colors.white),
                    ],
                  ),
                  // Row 5
                  Row(
                    children: [
                      _buildButton("0", Colors.grey[300]!, Colors.black),
                      _buildButton(".", Colors.grey[300]!, Colors.black),
                      _buildButton("=", Colors.blue, Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
