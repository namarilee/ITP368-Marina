// Marina Lee
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class GameState {
  List<int> caseValues;
  List<bool> caseOpened;
  int selectedCase;
  int bankOffer;
  bool gameOver;
  bool dealOffered;
  bool noDealPhase;
  int casesRevealed; // Track the number of revealed cases

  GameState(this.caseValues, this.caseOpened, this.selectedCase, this.bankOffer, this.gameOver, this.dealOffered, this.noDealPhase, this.casesRevealed);

  factory GameState.initial() { 
    List<int> initialCaseValues = [
      1, 5, 10, 100, 1000, 5000, 10000, 100000, 500000, 1000000
    ]..shuffle();

    List<bool> initialCaseOpened = List.generate(10, (index) => false);

    return GameState(initialCaseValues, initialCaseOpened, -1, 0, false, false, false, 0);
  }

  GameState copyWith({
    List<int>? caseValues,
    List<bool>? caseOpened,
    int? selectedCase,
    int? bankOffer,
    bool? gameOver,
    bool? dealOffered,
    bool? noDealPhase,
    int? casesRevealed,
  }) {
    return GameState(
      caseValues ?? this.caseValues,
      caseOpened ?? this.caseOpened,
      selectedCase ?? this.selectedCase,
      bankOffer ?? this.bankOffer,
      gameOver ?? this.gameOver,
      dealOffered ?? this.dealOffered,
      noDealPhase ?? this.noDealPhase,
      casesRevealed ?? this.casesRevealed,
    );
  }
}

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState.initial());

  // Select a case at the beginning of the game
  void selectInitialCase(int index) {
    if (state.selectedCase == -1 && !state.caseOpened[index]) {
      emit(state.copyWith(selectedCase: index));
      offerDeal();
    }
  }

  // Reveal a case after "No Deal"
  void revealCase(int index) {
    if (state.noDealPhase && !state.caseOpened[index] && index != state.selectedCase) {
      List<bool> updatedOpened = List.from(state.caseOpened);
      updatedOpened[index] = true;
      emit(state.copyWith(caseOpened: updatedOpened, noDealPhase: false)); // End the no deal phase
      offerDeal();
    }
  }

  // Calculate bank offer as 90% of the remaining hidden cases' average
  void offerDeal() {
    List<int> remainingValues = state.caseValues
        .asMap()
        .entries
        .where((entry) => !state.caseOpened[entry.key] && entry.key != state.selectedCase)
        .map((entry) => entry.value)
        .toList();

    if (remainingValues.isNotEmpty) {
      int bankOffer = (remainingValues.reduce((a, b) => a + b) / remainingValues.length * 0.9).round();
      emit(state.copyWith(bankOffer: bankOffer, dealOffered: true));
    } else {
      // No remaining values, end the game
      emit(state.copyWith(gameOver: true));
    }
  }

  // Player accepts deal
  void acceptDeal() {
    emit(state.copyWith(gameOver: true));
  }

  // Player rejects the deal, must reveal one suitcase
  void rejectDeal() {
    emit(state.copyWith(dealOffered: false, noDealPhase: true));
  }

  // Reset game to its initial state
  void resetGame() {
    emit(GameState.initial());
  }
}

void mainDeal() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameCubit>(
      create: (context) => GameCubit(),
      child: MaterialApp(
        title: 'Deal or No Deal - Marina',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deal or No Deal")),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, gameState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (gameState.selectedCase == -1)
                const Text('Choose your initial case:'),
              if (gameState.selectedCase != -1)
                const Text('Reveal a case or make a deal:'),
              
              // Case value list on the left
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CaseValueTable(
                      caseValues: gameState.caseValues,
                      caseOpened: gameState.caseOpened,
                    ),
                  ),

                  // Game grid for selecting cases on the right
                  Expanded(
                    flex: 5,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: gameState.caseValues.length,
                      itemBuilder: (context, index) {
                        bool isSelected = index == gameState.selectedCase;
                        bool isRevealed = gameState.caseOpened[index];
                        
                        return CaseButton(
                          index: index,
                          caseOpened: isRevealed,
                          isSelected: isSelected,
                          caseValue: gameState.caseValues[index],
                          onSelect: () {
                            if (gameState.selectedCase == -1) {
                              BlocProvider.of<GameCubit>(context).selectInitialCase(index);
                            } else if (gameState.noDealPhase && index != gameState.selectedCase) {
                              BlocProvider.of<GameCubit>(context).revealCase(index);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              if (gameState.dealOffered && !gameState.gameOver)
                Column(
                  children: [
                    Text('Bank Offer: \$${gameState.bankOffer}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<GameCubit>(context).acceptDeal();
                          },
                          child: const Text('Deal'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<GameCubit>(context).rejectDeal();
                          },
                          child: const Text('No Deal'),
                        ),
                      ],
                    ),
                  ],
                ),

              if (gameState.gameOver)
                Column(
                  children: [
                    const Text('Game Over!'),
                    Text('You won \$${gameState.bankOffer}'),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<GameCubit>(context).resetGame();
                      },
                      child: const Text('Restart Game'),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}



// Widget for each case button
class CaseButton extends StatelessWidget {
  final int index;
  final bool caseOpened;
  final bool isSelected;
  final int caseValue; // The value of the case
  final VoidCallback onSelect;

  CaseButton({
    required this.index,
    required this.caseOpened,
    required this.isSelected,
    required this.caseValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: caseOpened ? null : onSelect, // Disable button if case is opened
      style: ElevatedButton.styleFrom(
        backgroundColor: caseOpened ? Colors.grey : (isSelected ? Colors.orange : const Color.fromARGB(255, 246, 233, 181)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16),
      ),
      child: Text(
        caseOpened ? '\$${caseValue}' : 'Case ${index + 1}', // Display case value if opened
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CaseValueTable extends StatelessWidget {
  final List<int> caseValues;
  final List<bool> caseOpened;

  CaseValueTable({
    required this.caseValues,
    required this.caseOpened,
  });

  @override
  Widget build(BuildContext context) {
    // Sort the case values in descending order for display
    List<int> sortedCaseValues = List.from(caseValues)..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedCaseValues.map((value) {
        // Find the index of this value in the original list
        int index = caseValues.indexOf(value);
        bool isRevealed = caseOpened[index];

        // Use different color for revealed and hidden values
        Color textColor = isRevealed ? Colors.grey : Colors.black;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            '\$${value.toString()}',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: isRevealed ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }
}
