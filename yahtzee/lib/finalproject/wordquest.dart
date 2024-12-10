import 'package:flutter/material.dart';
import 'gameplay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
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
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'WordQuest',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: const Color.fromRGBO(54, 148, 155, 1)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WordQuest()),
              );
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 119, 74, 1), // Change button color to orange
                ),
              child: Text(
              'Start game',
              style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}