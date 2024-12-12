import 'package:google_fonts/google_fonts.dart';
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
  Map<int, int> playerScores = {1: 0, 2: 0}; // Track scores for each player
  Map<int, int> playerTurns = {1: 0, 2: 0};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDefinition();
  }

  Future<void> fetchDefinition() async {
    setState(() {
      isLoading = true;
    });
    try {
      int wordLength = playerLevels[currentPlayer]! + 2; // Level 1: 3 letters, Level 2: 4 letters, etc.
      bool definitionFound = false;

      while (!definitionFound) {
        // Random word API
        final wordResponse = await http.get(Uri.parse('https://random-word-api.herokuapp.com/word?number=1&length=$wordLength'));
        if (wordResponse.statusCode == 200) {
          final word = json.decode(wordResponse.body)[0];
          // Dictionary API
          final definitionResponse = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));

          if (definitionResponse.statusCode == 200) {
            final definitionData = json.decode(definitionResponse.body);
            final wordDefinition = definitionData[0]['meanings'][0]['definitions'][0]['definition'];

            setState(() {
              randomWord = word.toUpperCase();
              definition = wordDefinition;
              definitionFound = true;
              isLoading = false;
            });
          } else {
            // Retry fetching a new word if random word doesn't exist in dictionary
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
          playerScores[currentPlayer] = playerScores[currentPlayer]! + 10; // Increase score by 10 for each correct letter
        }
      }
      if (!isCorrect) {
        incorrectGuesses++;
        if (incorrectGuesses >= 3) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Incorrect!', style: GoogleFonts.kodchasan()),
                content: Text('The correct word was $randomWord', style: GoogleFonts.kodchasan()),
                actions: [
                  TextButton(
                    onPressed: () {                      
                      Navigator.of(context).pop();
                      switchPlayer(false); // stay at same level
                    },
                    child: Text('OK', style: GoogleFonts.kodchasan()),
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
                title: Text('Correct!', style: GoogleFonts.kodchasan()),
                content: Text('The correct word was $randomWord', style: GoogleFonts.kodchasan()),
                actions: [
                    TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      switchPlayer(true); // level up
                    },
                    child: Text('OK', style: GoogleFonts.kodchasan()),
                  ),
                ],
              );
            }, 
          );
      }
      keyColors[letter] = isCorrect ? const Color.fromRGBO(54, 148, 155, 1) : const Color.fromRGBO(255, 119, 74, 1);
    });
  }

  void switchPlayer(bool levelUp) {
    setState(() {
      if (levelUp) {
        playerLevels[currentPlayer] = (playerLevels[currentPlayer]! < 5) ? playerLevels[currentPlayer]! + 1 : 5; // Max level is 4
      }
      playerTurns[currentPlayer] = playerTurns[currentPlayer]! + 1; // Increment turn count for the current player

      if (playerTurns[1]! >= 5 && playerTurns[2]! >= 5) {
        // Both players have had 5 turns, end the game
        String winner;
        if (playerScores[1]! > playerScores[2]!) {
          winner = 'Player 1 wins!';
        } else if (playerScores[2]! > playerScores[1]!) {
          winner = 'Player 2 wins!';
        } else {
          winner = 'It\'s a tie!';
        }
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(winner, style: GoogleFonts.kodchasan()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      restartGame();
                    },
                    child: Text('Restart', style: GoogleFonts.kodchasan()),
                  ),
                ],
              );
            },
          );
          return;
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

  void restartGame() {
    setState(() {
      playerLevels = {1: 1, 2: 1};
      playerScores = {1: 0, 2: 0};
      playerTurns = {1: 0, 2: 0};
      currentPlayer = 1;
      incorrectGuesses = 0;
      guessedLetters = {1: ['', '', ''], 2: ['', '', '']};
      keyColors.clear();
      fetchDefinition();
    });
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = playerTurns[currentPlayer]! / 5; // Calculate progress based on turns

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 248, 246, 1),
      body: Padding(
      padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 60,
          bottom: 20,
        ),
        child: Column(
          children: [

            // Profile icon
            SizedBox(
              height: 50.0,
              child: Image.asset(
                currentPlayer == 1 ? 'lib/finalproject/img/butterflyprofile.png' : 'lib/finalproject/img/caterpillarprofile.png',
                width: 150,
                height: 150,
              ),
            ),

            // Text for player's turn
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Player $currentPlayer's Turn",
                  style: GoogleFonts.kodchasan(fontSize: 18),
                ),
              ),
            ),

            // Level indicator
            SizedBox(
              height: 20.0,
              child: Image.asset(
                'lib/finalproject/img/level${playerLevels[currentPlayer]}.png',
                width: 120,
                height: 120,
              ),
            ),

            // Progress bar
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 8.0),
                child: Text(
                  "Progress",
                  style: GoogleFonts.kodchasan(fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
              width: 350.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: LinearProgressIndicator(
                  value: progressValue,
                  color: const Color.fromRGBO(161, 236, 241, 1),
                  backgroundColor: const Color.fromRGBO(224, 236, 237, 1),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Boxes for each letter of the word
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
                      style: GoogleFonts.kodchasan(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: guessedLetters[currentPlayer]![index].isNotEmpty ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),

            // Strikes indicator
            SizedBox(
              height: 60.0, child:
            Image.asset(
              'lib/finalproject/img/strike$incorrectGuesses.png',
              width: 170,
              height: 170,
            ),
            ),
            SizedBox(height: 30),

            // Box containing the defition/clue
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
                    fontSize = 14;
                  }
                  if (definition.length > 200) {
                    fontSize = 11;
                  }
                    return SingleChildScrollView(
                    child: Column(
                      children: [
                      Text(
                        'CLUE',
                        style: GoogleFonts.kodchasan(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color.fromRGBO(47, 70, 160, 1)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      isLoading ? CircularProgressIndicator(backgroundColor: const Color.fromRGBO(54, 148, 155, 1), color: const Color.fromRGBO(161, 236, 241, 1)) : Text(
                        definition,
                        style: GoogleFonts.kodchasan(fontSize: fontSize),
                        textAlign: TextAlign.center,
                      ),
                      ],
                    ),
                    );
                },
              ),
            ),
            SizedBox(height: 10),

            // Regenerate button
            SizedBox(
              height: 25,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                  guessedLetters[currentPlayer] = List.filled(playerLevels[currentPlayer]! + 2, '');
                  keyColors.clear();
                  for (var letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) {
                    keyColors[letter] = const Color.fromRGBO(161, 236, 241, 1);
                  }
                  });
                  fetchDefinition();
                },
                icon: Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  'Regenerate',
                  style: GoogleFonts.kodchasan(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 119, 74, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Keyboard
            KeyBoard(onKeyPress, keyColors),
            SizedBox(height: 40),

            // Scorekeeping
            Container(
              padding: const EdgeInsets.all(7.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 239, 232, 1),
                border: Border.all(color: const Color.fromRGBO(188, 171, 152, 1)),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 35.0,
                    child: Image.asset(
                      'lib/finalproject/img/butterfly.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                Text(
                  '${playerScores[1]}',
                  style: GoogleFonts.kodchasan(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 10),
                SizedBox(
                    height: 30.0,
                    child: Image.asset(
                      'lib/finalproject/img/caterpillar.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                Text(
                  '${playerScores[2]}',
                  style: GoogleFonts.kodchasan(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
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
    Color backgroundColor = keyColors[letter] ?? const Color.fromRGBO(161, 236, 241, 1); // Default to blue color
    Color textColor = (backgroundColor == const Color.fromRGBO(161, 236, 241, 1)) ? Colors.black : Colors.white; // Change text color to white if guessed

    return Container(
      width: 32.5, 
      height: 42.0,
      child: TextButton(
        onPressed: () {
          onKeyPress(letter);
        },
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          letter,
          style: GoogleFonts.kodchasan(color: textColor, fontSize: 16),
        ),
      ),
    );
  }
}