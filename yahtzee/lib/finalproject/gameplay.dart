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
  Map<int, List<String>> guessedLetters = {1: ['','',''], 2: ['','','']};
  Map<String, Color> keyColors = {};
  int incorrectGuesses = 0;
  int currentPlayer = 1;
  Map<int, int> playerLevels = {1: 1, 2: 1}; // Track levels for each player

  @override
  void initState() {
    super.initState();
    fetchDefinition();
  }

  Future<void> fetchDefinition() async {
    setState(() {
      definition = 'Loading...';
    });
    try {
      int wordLength = playerLevels[currentPlayer]! + 2; // Level 1: 3 letters, Level 2: 4 letters, etc.
      bool definitionFound = false;

      while (!definitionFound) {
        final wordResponse = await http.get(Uri.parse('https://random-word-api.herokuapp.com/word?number=1&length=$wordLength'));
        if (wordResponse.statusCode == 200) {
          final word = json.decode(wordResponse.body)[0];
          final definitionResponse = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));

          if (definitionResponse.statusCode == 200) {
            final definitionData = json.decode(definitionResponse.body);
            final wordDefinition = definitionData[0]['meanings'][0]['definitions'][0]['definition'];

            setState(() {
              randomWord = word.toUpperCase();
              definition = wordDefinition;
              definitionFound = true;
            });
          } else {
            // Retry fetching a new word
            setState(() {
              definition = 'Definition not found. Retrying...';
            });
          }
        } else {
          setState(() {
            definition = 'Failed to fetch word.';
          });
        }
      }
    } catch (e) {
      setState(() {
        definition = 'Error occurred.';
      });
    }
  }

  void onKeyPress(String letter) {
    setState(() {
      bool isCorrect = false;
      for (int i = 0; i < randomWord.length; i++) {
        if (randomWord[i] == letter) {
          guessedLetters[currentPlayer]![i] = letter;
          isCorrect = true;
        }
      }
      if (!isCorrect) {
        incorrectGuesses++;
        if (incorrectGuesses >= 3) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Incorrect!'),
                content: Text('The correct word was $randomWord'),
                actions: [
                  TextButton(
                    onPressed: () {                      
                      Navigator.of(context).pop();
                      switchPlayer(false); // stay at same level
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } 
      } else if (!guessedLetters[currentPlayer]!.contains('')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Correct!'),
                content: Text('The correct word was $randomWord'),
                actions: [
                    TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      switchPlayer(true); // level up
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        //  switchPlayer();
      }
      keyColors[letter] = isCorrect ? const Color.fromRGBO(54, 148, 155, 1) : const Color.fromRGBO(255, 119, 74, 1);
    });
  }

  void switchPlayer(bool levelUp) {
    setState(() {
      if (levelUp) {
        playerLevels[currentPlayer] = (playerLevels[currentPlayer]! < 4) ? playerLevels[currentPlayer]! + 1 : 4; // Max level is 4
      }
      currentPlayer = currentPlayer == 1 ? 2 : 1;
      incorrectGuesses = 0;
      int wordLength = playerLevels[currentPlayer]! + 2; // Calculate word length based on player's level
      guessedLetters[currentPlayer] = List.filled(wordLength, '');
      keyColors.clear(); // Clear the key colors
      // Reset all key colors to blue
      for (var letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) {
        keyColors[letter] = const Color.fromRGBO(161, 236, 241, 1);
      }
      fetchDefinition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 248, 246, 1), // Set the background color of the entire screen
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 55,
          bottom: 20,
        ),
        child: Column(
          children: [
            
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Player $currentPlayer's Turn",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(
              height: 30.0, 
              child: Image.asset(
              'lib/finalproject/img/level1.png',
              width: 120,
              height: 120,
            ),
            ),
            
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 25.0, bottom: 8.0),
                child: Text(
                  "Progress",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
              width: 350.0,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: LinearProgressIndicator(
                  value: 0.5,
                  color: Color.fromRGBO(161, 236, 241, 1),
                  backgroundColor: Color.fromRGBO(224, 236, 237, 1),
                ),
              ),
            ),
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(guessedLetters[currentPlayer]!.length, (index) {
                return Container(
                  margin: EdgeInsets.only(right: index < guessedLetters[currentPlayer]!.length - 1 ? 10.0 : 0.0),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: guessedLetters[currentPlayer]![index].isNotEmpty ? const Color.fromRGBO(47, 70, 160, 1) : Colors.white,
                    border: guessedLetters[currentPlayer]![index].isNotEmpty ? Border.all(color: const Color.fromRGBO(47, 70, 160, 1)) : Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Center(
                    child: Text(
                      guessedLetters[currentPlayer]![index],
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: guessedLetters[currentPlayer]![index].isNotEmpty ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 60.0, child:
            Image.asset(
              'lib/finalproject/img/strike$incorrectGuesses.png',
              width: 170,
              height: 170,
            ),
            ),
            SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 239, 232, 1),
                border: Border.all(color: const Color.fromRGBO(188, 171, 152, 1)),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              constraints: BoxConstraints(
                maxHeight: 200.0,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double fontSize = 16;
                  if (definition.length > 100) {
                    fontSize = 16;
                  }
                  if (definition.length > 200) {
                    fontSize = 12;
                  }
                    return SingleChildScrollView(
                    child: Column(
                      children: [
                      Text(
                        'CLUE',
                        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color.fromRGBO(47, 70, 160, 1)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        definition,
                        style: TextStyle(fontSize: fontSize),
                        textAlign: TextAlign.center,
                      ),
                      ],
                    ),
                    );
                },
              ),
            ),
            SizedBox(height: 80),
            KeyBoard(onKeyPress, keyColors),
          ],
        ),
      ),
    );
  }
}

class KeyBoard extends StatelessWidget {
  final Function(String) onKeyPress;
  final Map<String, Color> keyColors;
  KeyBoard(this.onKeyPress, this.keyColors);

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
    Color backgroundColor = keyColors[letter] ?? const Color.fromRGBO(161, 236, 241, 1); // Default to blue if not guessed
    Color textColor = (backgroundColor == const Color.fromRGBO(161, 236, 241, 1)) ? Colors.white : Colors.black; // Change text color to white if guessed

    return Container(
      width: 32.5, // Set the desired width
      height: 42.0, // Set the desired height
      child: TextButton(
        onPressed: () {
          onKeyPress(letter);
        },
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor, // Change button color to orange
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          letter,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
    );
  }
}