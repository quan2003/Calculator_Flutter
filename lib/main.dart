import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _equation = "";
  String _currentNumber = "";
  String _operation = "";
  double _result = 0.0;

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _equation = "";
        _currentNumber = "";
        _operation = "";
        _result = 0.0;
      } else if (buttonText == "<--") {
        if (_currentNumber.isNotEmpty) {
          _currentNumber = _currentNumber.substring(0, _currentNumber.length - 1);
          if (_currentNumber.isEmpty) {
            _currentNumber = "0";
          }
          _output = _currentNumber;
        } else if (_equation.isNotEmpty) {
          // Xóa ký tự cuối cùng trong _equation
          _equation = _equation.trimRight();
          if (_equation.endsWith("+") || _equation.endsWith("-") || _equation.endsWith("*") || _equation.endsWith("/")) {
            _equation = _equation.substring(0, _equation.length - 1).trimRight();
          }
          if (_equation.isNotEmpty) {
            _currentNumber = _equation.split(' ').last;
          } else {
            _currentNumber = "0";
          }
        }
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "/" || buttonText == "*") {
        if (_currentNumber.isNotEmpty) {
          if (_equation.isNotEmpty && !_equation.endsWith(" ")) {
            _equation += " ";
          }
          _equation += "$_currentNumber $buttonText";
          _currentNumber = "";
        } else if (_equation.isNotEmpty && _equation.endsWith(" ")) {
          _equation = _equation.substring(0, _equation.length - 3) + " $buttonText";
        }
        _operation = buttonText;
      } else if (buttonText == "=") {
        if (_currentNumber.isNotEmpty) {
          _equation += " $_currentNumber";
          _result = _calculateResult();
          _output = _result.toString();
          _currentNumber = _output;
          _equation = "";
        }
      } else {
        if (_currentNumber == "0" && buttonText != ".") {
          _currentNumber = buttonText;
        } else {
          _currentNumber += buttonText;
        }
        _output = _currentNumber;
      }
    });
  }

  double _calculateResult() {
    List<String> parts = _equation.split(' ');
    double result = double.parse(parts[0]);
    for (int i = 1; i < parts.length; i += 2) {
      String op = parts[i];
      double num = double.parse(parts[i + 1]);
      switch (op) {
        case "+":
          result += num;
          break;
        case "-":
          result -= num;
          break;
        case "*":
          result *= num;
          break;
        case "/":
          if (num != 0) {
            result /= num;
          } else {
            return double.nan; // Xử lý chia cho 0
          }
          break;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calculate, size: 24), // Thêm biểu tượng máy tính
            SizedBox(width: 8), // Khoảng cách giữa biểu tượng và văn bản
            Text("Calculator"),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
                    child: Text(
                      _equation,
                      style: const TextStyle(fontSize: 24.0, color: Colors.blueGrey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
                    child: Text(
                      _output,
                      style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ..._buildCalculatorButtons(),
        ],
      ),
    );
  }

  List<Widget> _buildCalculatorButtons() {
    List<List<String>> buttons = [
      ["7", "8", "9", "/"],
      ["4", "5", "6", "*"],
      ["1", "2", "3", "-"],
      [".", "0", "00", "+"],
      ["C", "<--", "="] // Thay đổi nút "Backspace" thành "<--"
    ];
    return buttons.map((List<String> row) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: row.map((String buttonText) {
          if (buttonText == "<--") {
            return buildIconButton();
          } else {
            return buildButton(buttonText);
          }
        }).toList(),
      );
    }).toList();
  }

  Widget buildButton(String buttonText) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => buttonPressed(buttonText),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: _getButtonColor(buttonText),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 24.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildIconButton() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => buttonPressed("<--"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.orange, // Màu cho nút Backspace
        ),
        child: Icon(
          Icons.arrow_back, // Biểu tượng mũi tên
          size: 24.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getButtonColor(String buttonText) {
    if (buttonText == "C") {
      return Colors.red;
    } else if (buttonText == "=") {
      return Colors.green;
    } else if ("+-*/".contains(buttonText)) {
      return Colors.blue;
    }
    return Colors.grey;
  }
}