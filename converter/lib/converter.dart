import 'package:flutter/material.dart';

void main() {
  runApp(ConverterApp());
}

class ConverterApp extends StatelessWidget {
  ConverterApp({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "converter",
      home: ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  @override
  ConverterScreenState createState() => ConverterScreenState();
}

class ConverterScreenState extends State<ConverterScreen> {
  String input = '';
  String output = '';
  String conversionType = 'F to C'; // Default 

  // Handle button presses
  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        output = '';
      } else if (value == 'del') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else {
        input += value;
      }
    });
  }

  // Function to convert the input
  void convert() {
    double inputValue = double.tryParse(input) ?? 0;

    double result;
    if (conversionType == 'F to C') {
      result = (inputValue - 32) * 5 / 9;
    } else if (conversionType == 'C to F') {
      result = (inputValue * 9 / 5) + 32;
    } else if (conversionType == 'Pounds to Kg') {
      result = inputValue * 0.453592;
    } else if (conversionType == 'Kg to Pounds') {
      result = inputValue / 0.453592;
    } else {
      result = 0;
    }

    setState(() {
      output = result.toStringAsFixed(2);
    });
  }

  // Change conversion type
  void changeConversion(String newType) {
    setState(() {
      conversionType = newType;
      input = '';
      output = '';
    });
  }

  Widget buildButton(String value) {
    return FloatingActionButton(
      onPressed: () => onButtonPressed(value),
      child: Text(
        value,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Converter'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () => changeConversion('F to C'),
                child: Text('F to C'),
              ),
              FloatingActionButton(
                onPressed: () => changeConversion('C to F'),
                child: Text('C to F'),
              ),
              FloatingActionButton(
                onPressed: () => changeConversion('Pounds to Kg'),
                child: Text('Pounds to Kg'),
              ),
              FloatingActionButton(
                onPressed: () => changeConversion('Kg to Pounds'),
                child: Text('Kg to Pounds'),
              ),
            ],
          ),
          SizedBox(height: 20),

          Text(
            'Conversion Type: $conversionType',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Input: $input',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            'Output: $output',
            style: TextStyle(fontSize: 24, color: Colors.green),
          ),
          SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton('1'),
              SizedBox(width: 16),
              buildButton('2'),
              SizedBox(width: 16),
              buildButton('3'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton('4'),
              SizedBox(width: 16),
              buildButton('5'),
              SizedBox(width: 16),
              buildButton('6'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton('7'),
              SizedBox(width: 16),
              buildButton('8'),
              SizedBox(width: 16),
              buildButton('9'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton('0'),
              SizedBox(width: 16),
              buildButton('.'),
              SizedBox(width: 16),
              buildButton('-'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                SizedBox(
                  width: 100,
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: () => convert(),
                    backgroundColor: const Color.fromARGB(255, 251, 227, 191),
                    child: Text('Convert', style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 56, 44, 27),)),
                  ),
                ),
                SizedBox(width: 16),
              buildButton('del'),
              SizedBox(width: 16),
              buildButton('C'),
          
            ],
          ),
         
        ],
      ),
    );
  }
}
