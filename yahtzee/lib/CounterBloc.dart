import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";

class CountState {
	int count;
	CountState(this.count);
}

class CountCubit extends Cubit<CountState> {
		CountCubit() : super( CountState(0) );
		void update(int s) { emit(CountState(s)); }
}

void main() {
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return BlocProvider<CountCubit>(
			create: (context) => CountCubit(),
			child:  MaterialApp
			( title: "CounterBLoC - Marina",
				home: MyHomePage(),
			),
		);
	}
}

class MyHomePage extends StatelessWidget {
	
	int incrementCounter(BuildContext context) {
			CountCubit countCubit = BlocProvider.of<CountCubit>(context);
			int theCount = countCubit.state.count;
			countCubit.update(theCount + 1);
			return theCount;
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text("counterBLoC")),
			body:  BlocBuilder<CountCubit, CountState>(
				builder: (context, countState) {
					return Column(
					
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							const Text(
								'You have pushed the button this many times:',
							),
							Text(
								'${countState.count}',
								style: Theme.of(context).textTheme.headlineMedium,
							),
						
							FloatingActionButton(
								onPressed: () { 
									// int count = incrementCounter(context);
									// CountCubit countCubit = BlocProvider.of<CountCubit>(context);
									incrementCounter(context);
								},
								tooltip: 'Increment',
								child: const Icon(Icons.add),
							),
						]
					);
				},
			),
		);
	}
}


