import 'package:flutter/material.dart';

void main() { // Ax
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData
      ( useMaterial3: true,
        colorScheme: ColorScheme.fromSeed
        ( seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme
        ( displayLarge: TextStyle
          ( fontSize: 50,
            color: Colors.purple, 
          ),
          titleLarge: TextStyle
          ( fontSize: 40,
            color: Colors.orange,
          ),
          titleMedium: TextStyle
          ( fontSize: 30, color: Color(0xee44cc11) ),
          bodyMedium: TextStyle
          ( fontSize: 30, color: Colors.yellow 
          ),
          displaySmall: TextStyle
          ( fontSize: 20, color: Colors.green ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData
        ( style: TextButton.styleFrom
          ( foregroundColor: Colors.green ,
            backgroundColor: Color( 0xffeeaadd ),
            textStyle: TextStyle(fontSize: 50 ),
          ),
        ),
        textButtonTheme: TextButtonThemeData
        ( style: TextButton.styleFrom
          ( foregroundColor: Colors.black ,
            backgroundColor: Color( 0xff55ddcc ),
            textStyle: TextStyle(fontSize: 50 ),
          ),
        ),
        appBarTheme: AppBarTheme
        ( backgroundColor: Colors.purple,
          foregroundColor: Colors.orange,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              // style: Theme.of(context).textTheme.headlineMedium,
            ),
            Semantics
            ( label: "button to add 1",
              child:  FloatingActionButton
              (
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ), 
            Row
            ( children:
      [ ElevatedButton
                ( onPressed: (){},
                  child: Text("useless"),
                ),
                Text("some text"),
                TextButton
                ( onPressed: (){},
                  child: Text("other"),
                ),
                AnimatedContainer
                ( duration: Duration(seconds:2),
                  color: _counter%2==0? Colors.red : Colors.blue,
                  child: Text("wave"),
                ),

              ],
           
            ),
          ],
        ),
      ),
    );
  }
}
