import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

class PancakeStackState {
  final List<int> pancakes;
  final int flips;
  final bool sorted;

  PancakeStackState({required this.pancakes, this.flips = 0, this.sorted = false});
}

class PancakeStackCubit extends Cubit<PancakeStackState> {
  PancakeStackCubit() : super(PancakeStackState(pancakes: []));

  void createRandomStack(int count) {
    List<int> stack = List.generate(count, (i) => i + 1);
    stack.shuffle(Random());
    emit(PancakeStackState(pancakes: stack));
  }

  void flipAt(int index) {
    List<int> newStack = List.from(state.pancakes);
    newStack = newStack.sublist(0, index + 1).reversed.toList() + newStack.sublist(index + 1);
    bool sorted = isSorted(newStack);
    emit(PancakeStackState(pancakes: newStack, flips: state.flips + 1, sorted: sorted));
  }

  bool isSorted(List<int> stack) {
    for (int i = 0; i < stack.length - 1; i++) {
      if (stack[i] > stack[i + 1]) {
        return false;
      }
    }
    return true;
  }

  void reset() {
    emit(PancakeStackState(pancakes: state.pancakes, flips: 0));
  }
}

void main() {
  runApp(const PancakeSortingApp());
}

class PancakeSortingApp extends StatelessWidget {
  const PancakeSortingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PancakeStackCubit(),
      child: MaterialApp(
        title: 'pancakes - marina',
        home: PancakeSortingHomePage(),
      ),
    );
  }
}

class PancakeSortingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pancakeCubit = BlocProvider.of<PancakeStackCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('pancakes - marina'),
      ),
      body: BlocBuilder<PancakeStackCubit, PancakeStackState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 20),
              pancakeStack(state, context),
              const SizedBox(height: 20),
              Text('Flips: ${state.flips}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              if (state.sorted)
                Text('You sorted the stack!', style: TextStyle(color: Colors.green, fontSize: 24)),
              actions(context),
            ],
          );
        },
      ),
    );
  }

  Widget pancakeStack(PancakeStackState state, BuildContext context) {
    return Column(
      children: state.pancakes
          .asMap()
          .entries
          .map((entry) => GestureDetector(
                onTap: () {
                  if (!state.sorted) {
                    BlocProvider.of<PancakeStackCubit>(context).flipAt(entry.key);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  width: 20.0 * entry.value,
                  height: 30,
                  color: Colors.pink[entry.value * 100],
                  child: Center(
                    child: Text(
                      entry.value.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  // buttons for Reset and New Stack
  Widget actions(BuildContext context) {
    final pancakeCubit = BlocProvider.of<PancakeStackCubit>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                pancakeCubit.createRandomStack(pancakeCubit.state.pancakes.length - 1);
              },
            ),
            Text(
              '${pancakeCubit.state.pancakes.length} Pancakes',
              style: const TextStyle(fontSize: 18),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                pancakeCubit.createRandomStack(pancakeCubit.state.pancakes.length + 1);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            pancakeCubit.reset();
            pancakeCubit.createRandomStack(pancakeCubit.state.pancakes.length);
          },
          child: const Text('Reset'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            pancakeCubit.createRandomStack(pancakeCubit.state.pancakes.length);
          },
          child: const Text('New Stack'),
        ),
      ],
    );
  }
}