import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() =>
    runApp(MaterialApp(home: Calculator(), debugShowCheckedModeBanner: false));

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  String userInput = "";
  String result = "0";
  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdedede),
      body: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                child: Text(
                  userInput,
                  style: TextStyle(fontSize: 32, color: Colors.black),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerRight,
                child: Text(
                  result,
                  style: TextStyle(
                      fontSize: 48,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        //Divider(color: Colors.white),
        Expanded(
            child: Container(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: buttonList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemBuilder: (BuildContext context, int index) {
              return CustomButton(buttonList[index]);
            },
          ),
        ))
      ]),
    );
  }

  Widget CustomButton(String text) {
    return InkWell(
      splashColor: Color(0xFF1d2630),
      onTap: () {
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
            color: getBgColor(text),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 0.5,
                offset: Offset(-3, -3),
              )
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: getColor(text),
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  getColor(String text) {
    if (text == "=") {
      return Colors.white;
    }
    return Colors.black;
  }

  getBgColor(String text) {
    if (text == "AC" ||
        text == "/" ||
        text == "*" ||
        text == "+" ||
        text == "-" ||
        text == "C" ||
        text == "(" ||
        text == ")") {
      return Color.fromARGB(255, 191, 207, 217);
    }
    if (text == "=") {
      return Color.fromARGB(255, 6, 175, 248);
    }
    return Colors.white;
  }

  handleButtons(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
      return;
    } else if (text == "C") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return null;
      }
    } else if (text == "=") {
      if (userInput.isEmpty) {
        return "";
      }
      result = calculate();
      userInput = result;
      if (userInput.endsWith(".0")) {
        userInput = userInput.replaceAll(".0", "");
      }
      if (result.endsWith(".0")) {
        result = result.replaceAll(".0", "");
      }
      return;
    } else if (text == "/" || text == "*" || text == "+" || text == "-"|| text==")") {
      if (userInput.isEmpty) {
        return "";
      }
    }
    userInput = userInput + text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return "";
    }
  }
}
