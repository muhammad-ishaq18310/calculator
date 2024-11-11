// ignore_for_file: avoid_unnecessary_containers

import 'package:calculator/buttons_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // 0 to 9
  String operand = ""; //  +,_,/,*
  String number2 = "";

  /// 0 to 9

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //out put
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                        width: value == Btn.n0
                            ? screenSize.width / 2
                            : (screenSize.width / 4),
                        height: screenSize.width / 5,
                        child: buildButton(value)),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtncolor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
//+++++++++++++++++++++++++++++

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertToPercent();
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendvalue(value);
  }

  //++++============== calculate the result
  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;

        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;

      default:
    }
    setState(() {
      number1 = "$result";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

//======================= conversion to percentage function
  void convertToPercent() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
//calculate befor conversion
      //todo
      //final res= number1 operant number2;
      //number1=res;
      calculate();
    }
    if (operand.isNotEmpty) {
      ///cannot be converted
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  ///===================== for clear function
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }
//=========== function for dwlwt

  void delete() {
    if (number2.isNotEmpty) {
      // 1234 =>123
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

//++++++++++++++++++++++
  void appendvalue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        //todo calculate the equation
        calculate();
      }
      operand = value;
    }
    //=========== assign value to number 1
    else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = '0.';
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = '0.';
      }
      number2 += value;
    }

    setState(() {});
  }

//+++++++++++++++++++++++++++++++++++++
  Color getBtncolor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
