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
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to',
              style: GoogleFonts.kodchasan(fontSize: 24),
            ),
            Text(
              'WordQuest',
              style: GoogleFonts.kodchasan(fontSize: 40, fontWeight: FontWeight.bold, color: const Color.fromRGBO(54, 148, 155, 1)),
            ),
            SizedBox(height: 250),
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
    );
  }
}