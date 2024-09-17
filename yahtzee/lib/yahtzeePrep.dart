// Marina Lee

import "dart:math";

import "package:flutter/material.dart";

void main2() // 23
{
  runApp(Yahtzee());
}

class Yahtzee extends StatelessWidget
{
  Yahtzee({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "yahtzee",
      home: YahtzeeHome(),
    );
  }
}

class YahtzeeHome extends StatefulWidget
{
  @override
  State<YahtzeeHome> createState() => YahtzeeHomeState();
}

class YahtzeeHomeState extends State<YahtzeeHome>
{
  var total = 0;
  List<Dice> dice = [Dice(), Dice(), Dice(), Dice(), Dice(),];

  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text("yahtzee")),
      body:  Column( 
        children: [ 
          SizedBox(
            width: 100,
            height: 70,
            child: FloatingActionButton( 
              onPressed: () { 
                setState( () { 
                  total = 0;
                  for ( Dice d in dice )
                  { total += d.roll(); } 
                }
                );
              },
            child: Text("roll all", style: TextStyle(fontSize: 30)),
            ),
          ),
          Text("total $total", style: TextStyle(fontSize: 30)),
          Row( children: dice, ),
        ]
      ),
    );
  }
}

class Dot extends Positioned
{
  Dot(  {super.top, super.left } )
  : super
    ( child: Container
      ( height: 10, width: 10,
        decoration: BoxDecoration
        ( color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
}

class Dice extends StatefulWidget {
  final DiceState ds = DiceState();
  @override
  State<Dice> createState() => ds;

  int roll() { return ds.roll(); }

}

class DiceState extends State<Dice> {
  var face = 0;
  bool isHold = false;
  final rand = Random();

  int roll() {
    if (!isHold) {
      setState (
        () { face = rand.nextInt(6) + 1; }
      );
    }
    return face;
  }

  Widget build( BuildContext context ) {
    List<Dot> dots = [];
    if (face == 1) {
      dots.add(Dot(top: 40, left: 45)); 
    }
    if (face == 2) {
      dots.add(Dot(top: 10, left: 20));
      dots.add(Dot(top: 70, left: 70));
    }
    if (face == 3) {
      dots.add(Dot(top: 10, left: 20));
      dots.add(Dot(top: 70, left: 70));
      dots.add(Dot(top: 40, left: 45)); 
    }
    if (face == 4) {
      dots.add(Dot(top: 70, left: 20));
      dots.add(Dot(top: 10, left: 70));
      dots.add(Dot(top: 10, left: 20));
      dots.add(Dot(top: 70, left: 70));
    }
    if (face == 5) {
      dots.add(Dot(top: 10, left: 20));
      dots.add(Dot(top: 70, left: 70));
      dots.add(Dot(top: 40, left: 45));
      dots.add(Dot(top: 10, left: 70));
      dots.add(Dot(top: 70, left: 20));
    }
    if (face == 6) {
      dots.add(Dot(top: 10, left: 20));
      dots.add(Dot(top: 70, left: 70));
      dots.add(Dot(top: 10, left: 70));
      dots.add(Dot(top: 70, left: 20));
      dots.add(Dot(top: 40, left: 20));
      dots.add(Dot(top: 40, left: 70));
    }

    return Column
    ( children: 
      [ Container
        ( decoration: BoxDecoration
          ( border: Border.all( width:2, ) ,
            color: (isHold? Colors.pink: Colors.white),
          ),
          height: 100, width: 100, 
          child: Stack( children:dots, ),
        ),
        FloatingActionButton
        ( onPressed: (){ setState((){ isHold = !isHold;}); },
          child: Text("hold"),
        ),
        // just for debugging
        FloatingActionButton
        ( onPressed: (){ setState((){ roll(); }); },
          child: Text("roll"),
        ),
      ],
    );
  }
}

