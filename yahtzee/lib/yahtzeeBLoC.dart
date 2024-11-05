// Barrett Koster
// This is a finished Yahtzee roller.
// I am converting it to BLoC.

import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SumState
{
  int sum;

  SumState( this.sum );
}
class SumCubit extends Cubit<SumState>
{
  SumCubit() : super( SumState(0) );

  void update(int s) { emit(SumState(s)); }
}

void main() // 27
{
  runApp(Yahtzee());
}

class Yahtzee extends StatelessWidget
{
  Yahtzee({super.key});

  @override
  Widget build( BuildContext context )
  { return BlocProvider<SumCubit>
    ( create: (context) => SumCubit(),
      child:  MaterialApp
      ( title: "yahtzeeBLoC - Barrett",
        home: YahtzeeHome(),
      ),
    );
  }
}

class YahtzeeHome extends StatelessWidget
{
  List<Dice> theDice = [Dice(),Dice(),Dice(),Dice(),Dice(), ];
  @override
  Widget build( BuildContext context )
  { return Scaffold
    ( appBar: AppBar(title: const Text("yahtzeeBLoC")),
      body: BlocBuilder<SumCubit,SumState>
      ( builder: (context,sumState)
        { return Column 
          ( children:
            [ FloatingActionButton
              ( onPressed: ()
                { int sum = rollAll();
                  SumCubit sumCubit = 
                    BlocProvider.of<SumCubit>(context);
                  sumCubit.update(sum);
                },
                child: const Text("roll all",style:TextStyle(fontSize:30)),
              ),
              Text("total ${sumState.sum}",style:const TextStyle(fontSize:30)),
              Row( children: theDice, ),
            ]
          );
        },
      ),
    );
  }

  int rollAll()
  { int total = 0;
    for ( Dice d in theDice )
    { total += d.d1.roll(); }
    return total;
  }
}

class DiceState
{
   int face;
   bool hold;

   DiceState( this.face, this.hold );
}
class DiceCubit extends Cubit<DiceState>
{
  DiceCubit() : super( DiceState(0,false) );

  void updateHold( bool h ){ emit(DiceState(state.face,h) ); }
  void updateFace(  int f ){ emit(DiceState(f,state.hold) ); }
}

// shows a box with dots and a 'hold' button
// debugging: and a 'roll' button
class Dice extends StatelessWidget
{ late Dice1 d1;
  Widget build( BuildContext context )
  { return BlocProvider<DiceCubit>
    ( create: (cotext) => DiceCubit(),
      child: BlocBuilder<DiceCubit,DiceState>
      ( builder: (context,state)
        { return d1=Dice1(); },
      ),
    );
  }
}

class Dice1 extends StatelessWidget
{ static final randy = Random();
  late BuildContext bc;
  Widget build( BuildContext context )
  { bc = context;
    List<Dot> dots = [];
    DiceCubit dCubit = BlocProvider.of<DiceCubit>(context);
    DiceState dState = dCubit.state;
    int face = dState.face;
    bool holding = dState.hold;
    if ( face>1 ) // upper left and lower right
    { dots.add( Dot(top:10,left:20) );
      dots.add( Dot(top:70, left:70) );
    }
    if ( face>3 ) // other corners
    { dots.add( Dot(top:10,left:70) );
      dots.add( Dot(top:70, left:20) );
    }
    if (face==4 || face==6 ) // middle side dots
    { dots.add( Dot(top:40,left:20) );
      dots.add( Dot(top:40, left:70) );
    }
    if ( face==1 || face==3 || face==5 ) // center dot
    { dots.add( Dot(top:40,left:45) ); 
    }

    // the box with dots and two buttons
    return Column
    ( children: 
      [ Container
        ( decoration: BoxDecoration
          ( border: Border.all( width:2, ) ,
            color: (holding? Colors.pink: Colors.white),
          ),
          height: 100, width: 100, 
          child: Stack( children:dots, ),
        ),
        FloatingActionButton
        ( onPressed: (){ dCubit.updateHold(!dState.hold); },
          child: const Text("hold"),
        ),
        // just for debugging
        FloatingActionButton
        ( onPressed: () { dCubit.updateFace( roll() ); },
          child: Text("roll"),
        ),
      ],
    );
  }

  int roll()
  {
    DiceCubit dCubit = BlocProvider.of<DiceCubit>(bc);
    DiceState dState = dCubit.state;
    int f = dState.face;
    if ( !dState.hold )
    { f = randy.nextInt(6)+1; 
      dCubit.updateFace(f);
    }
    return f;
  }
}

// is one dot on the (showing) face of a Dice (die).
// A Dot knows where it is suppose to be because it 
// extends a Positioned.  The coordinates have to be
// named in the constructor call.
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