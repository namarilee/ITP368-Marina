/*
  Kenny's
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class for state management. the "box" contains a sound 
class AnimalSoundSTATE {
  final String sound;
  AnimalSoundSTATE(this.sound);
}

// class for which animal has been selected
class SelectedAnimalSound{
  String sound;
  SelectedAnimalSound(this.sound);
}

class AnimalSoundBloc extends Bloc<AnimalSoundEVENT, AnimalSoundSTATE> {
  AnimalSoundBloc() : super(AnimalSoundSTATE('')) { // initialization of the constructor to have an empty state for the animal sound

// function to listen for SelectedAnimalSound event, updates AnimalSoundSTATE 
    on<SelectedAnimalSound>((event, emit) {
      emit(AnimalSoundSTATE(event.sound));
    });
  }

}

// main void
void main() {
  runApp(MyApp());
}

// main root
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => AnimalSoundBloc(),
        child: Home(),
      ),
    );
  }
}

// ========================== main screen ========================== //
class Home extends StatelessWidget {
  final Map<String, String> animalPairs = {
    // map animals to their sounds
    'dog': 'bark',
    'pig': 'oink',
    'snake': 'hiss',
    'bird': 'chirp',
    'cow': 'moo',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Speak')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        // ========================== list of animals ========================== //
        children: [
          Expanded(
            child: ListView(
              children: animalPairs.keys.map((animal) {
                // iterate through animals pair map and list animals as a list
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(

// when pressed, button will trigger onPressed
onPressed: () {
// retrieves the instance of AnimalSoundBloc from the current widget tree (connects button to BLoC) 
                      BlocProvider.of<AnimalSoundBloc>(context)
// .add() is used to dispatch a SelectedAnimalSound event to BLoC 
// .we pass the current animal selected as a parameter to get its corresponding sound in the map
// finally passing this sound into SelectedAnimalSound 
.add(SelectedAnimalSound(animalPairs[animal]!)); 
                    },
                    child: Text(animal), // display the animal chosen
                  ),
                );
              }).toList(), // convert list of animals to an actual list
            ),
          ),

          // ========================== corresponding animal sound ========================== //
          BlocBuilder<AnimalSoundBloc, AnimalSoundSTATE>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(20.0),

// pulls corresponding sound from selected animal from state to display
                child: Text(
                  state.sound,
                  style: TextStyle(fontSize: 24),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


*/