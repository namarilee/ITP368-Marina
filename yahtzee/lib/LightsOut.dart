import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";

class CountState {
  double count = 9;
  List<bool> lightStates; 

  CountState(this.count, this.lightStates);

  // Creates an initial state with all lights off
  factory CountState.initial(double count) {
    return CountState(count, List.generate(count.round(), (index) => false));
  }

  // Updates the light state at a specific index
  CountState copyWith({double? count, List<bool>? lightStates}) {
    return CountState(
      count ?? this.count,
      lightStates ?? this.lightStates,
    );
  }
}

class CountCubit extends Cubit<CountState> {
  CountCubit() : super(CountState.initial(9));

  // Update the number of lights
  void update(double s) {
    int newCount = s.round();
    List<bool> updatedLights = List.generate(newCount, (index) => false);
    emit(CountState(s, updatedLights));
  }

  void toggleLight(int index) {
    List<bool> updatedLights = List.from(state.lightStates);

    updatedLights[index] = !updatedLights[index];

    if (index > 0) {
      updatedLights[index - 1] = !updatedLights[index - 1];
    }

    if (index < updatedLights.length - 1) {
      updatedLights[index + 1] = !updatedLights[index + 1];
    }

    emit(state.copyWith(lightStates: updatedLights));
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CountCubit>(
      create: (context) => CountCubit(),
      child: MaterialApp(
        title: "LightsOut - Marina",
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LightsOut")),
      body: BlocBuilder<CountCubit, CountState>(
        builder: (context, countState) {
          double screenWidth = MediaQuery.of(context).size.width;
          int lightCount = countState.count.round();

          // Calculate size of each light based on the number of lights and screen width
          double lightSize = (screenWidth / lightCount) - 10; 

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Number of lights:'),
              Text(
                '${countState.count}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Slider(
                value: countState.count,
                min: 3,
                max: 15,
                divisions: 12,
                label: countState.count.round().toString(),
                onChanged: (double value) {
                  BlocProvider.of<CountCubit>(context).update(value);
                },
              ),
              // Ensure the lights always fit in one row
              SizedBox(
                height: lightSize + 20, // Provide enough height for the buttons
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: lightCount,
                  itemBuilder: (context, index) {
                    return Light(
                      index: index,
                      lightSize: lightSize, 
                      isOn: countState.lightStates[index], 
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Light extends StatelessWidget {
  final int index;
  final double lightSize;
  final bool isOn;

  Light({required this.index, required this.lightSize, required this.isOn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: lightSize,
      height: lightSize,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: FloatingActionButton(
        onPressed: () {
          // Toggle the clicked light and its neighbors
          BlocProvider.of<CountCubit>(context).toggleLight(index);
        },
        backgroundColor: isOn ? Colors.yellow : Colors.grey,
        child: Icon(
          isOn ? Icons.lightbulb : Icons.lightbulb_outline,
          size: lightSize * 0.5, // Adjust icon size proportionally
        ),
      ),
    );
  }
}
