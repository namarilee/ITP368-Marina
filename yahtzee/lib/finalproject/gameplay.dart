// experimenting with free dictionary api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class WordQuest extends StatefulWidget {
  @override
  _WordQuestState createState() => _WordQuestState();
}

class _WordQuestState extends State<WordQuest> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 100,
                bottom: 20,
              ),
        child: Column(
            children: [
            SizedBox(
              height: 300,
              child: Column(
              children: [
                const Text(
                "Player 1's Turn",
                style: TextStyle(fontSize: 24),
                ),
                const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                  "Progress",
                  style: TextStyle(fontSize: 14),
                  ),
                ),
                ),
                const SizedBox(
                height: 10.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: LinearProgressIndicator(
                  value: 0.5,
                  color: Color.fromRGBO(161, 236, 241, 1),
                  backgroundColor: Color.fromRGBO(224, 236, 237, 1),
                  ),
                ),
                ),
                Image.asset(
                'lib/finalproject/img/strike0.png',
                width: 170,
                height: 170,
                ),
              ],
              ),
            ),
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              );
              }),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 239, 232, 1),
                border: Border.all(color: const Color.fromRGBO(188, 171, 152, 1)),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: const Text(
                'This is a paragraph of text inside a box. You can add more text here to provide additional information or instructions.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 100),
            KeyBoard(_controller),
          ],
        ),
      ),
    );
  }
}

class KeyBoard extends StatelessWidget
{
  final TextEditingController controller;
  KeyBoard( this.controller );

  Widget build( BuildContext context )
  {
    return Column(
      children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        ky("Q"), ky("W"), ky("E"), ky("R"), ky("T"),
        ky("Y"), ky("U"), ky("I"), ky("O"), ky("P"),
        ],
      ),
      SizedBox(height: 10), // Add spacing between rows
      SizedBox (width: 330, child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          ky("A"), ky("S"), ky("D"), ky("F"), ky("G"),
          ky("H"), ky("J"), ky("K"), ky("L"),
          ],
        ),
      ),
      SizedBox(height: 10), // Add spacing between rows
      SizedBox (width: 270, child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        ky("Z"), ky("X"), ky("C"), ky("V"), ky("B"),
        ky("N"), ky("M"),
        ],
      ),
      ),
      ],
    );
  }

  Widget ky(String letter, {double borderRadius = 10.0}) {
    return Container(
      width: 32.0, // Set the desired width
      height: 38.0, // Set the desired height
      child: TextButton(
        onPressed: () {
          // Button onPressed action
        },
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromRGBO(161, 236, 241, 1), // Change button color to orange
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          letter,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
}