// experimenting with free dictionary api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class WordQuest extends StatefulWidget {
  @override
  _WordQuestState createState() => _WordQuestState();
}

class _WordQuestState extends State<WordQuest> {
  String definition = 'Loading...';
  String randomWord = '';
  List<String> guessedLetters = ['', '', ''];

  @override
  void initState() {
    super.initState();
    fetchDefinition();
  }
  Future<void> fetchDefinition() async {
    try {
      // Fetch a random word of length 3
      final wordResponse = await http.get(Uri.parse('https://random-word-api.herokuapp.com/word?number=1&length=3'));
      if (wordResponse.statusCode == 200) {
        final word = json.decode(wordResponse.body)[0];
        setState(() {
          randomWord = word.toUpperCase();
        });

        // Fetch the definition of the word
        final definitionResponse = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
        if (definitionResponse.statusCode == 200) {
          final definitionData = json.decode(definitionResponse.body);
          final wordDefinition = definitionData[0]['meanings'][0]['definitions'][0]['definition'];

          setState(() {
            definition = wordDefinition;
          });
        } else {
          setState(() {
            definition = 'Definition not found.';
          });
        }
      } else {
        setState(() {
          definition = 'Failed to fetch word.';
        });
      }
    } catch (e) {
      setState(() {
        definition = 'Error occurred.';
      });
    }
  }

  void onKeyPress(String letter) {
    setState(() {
      for (int i = 0; i < randomWord.length; i++) {
        if (randomWord[i] == letter) {
          guessedLetters[i] = letter;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20,
                bottom: 20,
              ),
        child: Column(
            children: [
              Image.asset(
                'lib/finalproject/img/strike0.png',
                width: 170,
                height: 170,
                ),
              const SizedBox(height: 0),
            const SizedBox(
              
              height: 150,
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
              ],
              ),
            ),
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                margin: EdgeInsets.only(right: index < 2 ? 10.0 : 0.0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Center(
                    child: Text(
                      guessedLetters[index],
                      style: TextStyle(fontSize: 24),
                    ),
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
              child: Text(
                definition,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 100),
            KeyBoard(onKeyPress),
          ],
        ),
      ),
    );
  }
}

class KeyBoard extends StatelessWidget {
  final Function(String) onKeyPress;
  KeyBoard(this.onKeyPress);

  @override
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
      height: 42.0, // Set the desired height
      child: TextButton(
        onPressed: () {
          onKeyPress(letter);
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