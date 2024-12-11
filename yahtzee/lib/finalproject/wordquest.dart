import 'package:flutter/material.dart';
import 'gameplay.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(245, 239, 232, 1), // Set background color
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 200,
            bottom: 20,
          ),
          child: Column(
            children: <Widget>[
              Image.asset("lib/finalproject/img/wordquestlogo.png", width: 370, height: 370,),
              SizedBox(height: 150),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WordQuest()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 119, 74, 1), // Change button color to orange
                  minimumSize: Size(200, 50), // Set button width and height
                ),
                child: Text(
                  'Start game',
                  style: GoogleFonts.kodchasan(color: Colors.white, fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}