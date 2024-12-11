// Barrett Koster
// keyboard demo

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/bb.dart';

class KeyboardState
{
  bool showit = false;
  KeyboardState( this.showit );
}
class KeyboardCubit extends Cubit<KeyboardState>
{
  KeyboardCubit() : super( KeyboardState(false) );
  set( bool s ) { emit( KeyboardState(s) ); }
}

void main() async
{ runApp(const KD());

}

class KD extends StatelessWidget 
{ const KD({super.key});
  final title = "Keyboard Demo";

  @override
  Widget build(BuildContext context) 
  { return  MaterialApp
    ( 
      title: title,
      home: Scaffold
      ( appBar: AppBar( title: BB(title) ),
        body: BlocProvider<KeyboardCubit>
        ( create: (context) => KeyboardCubit(),
          child: BlocBuilder<KeyboardCubit,KeyboardState>
          ( builder: (context,state)
            { return KD1(); },
          ),
        ),
      ),
    );
  }
}

class KD1 extends StatelessWidget 
{ KD1({super.key});
  final TextEditingController tec = TextEditingController();

  @override
  Widget build(BuildContext context)
  { KeyboardCubit kc = BlocProvider.of<KeyboardCubit>(context);
    return Column
    ( children:
      [ BB("hi there"),
        SizedBox
        ( height: 50, width: 200,
          child: Focus
          ( onFocusChange:(hasFocus) { kc.set( hasFocus); },
            child: TextField
            ( controller:tec, style:TextStyle(fontSize: 25) ,
              
            ), 
          ),
        ),
        kc.state.showit ? KeyBoard( tec ) : Text("xxx"),
      ],
    );
  }
}

class KeyBoard extends StatelessWidget
{
  TextEditingController tec;
  KeyBoard( this.tec );

  Widget build( BuildContext context )
  {
    return Column
    ( children:
      [ 
        Row
        ( children: 
          [ ky("Q"),ky("W"),ky("E"),ky("R"),ky("T"),
            ky("Y"),ky("U"),ky("I"),ky("O"),ky("P"),
          ],
        ),
        Row
        ( children: 
          [ ky("A"),ky("S"),ky("D"),ky("F"),ky("G"),
            ky("H"),ky("J"),ky("K"),ky("L"),
          ],
        ),
        Row
        ( children: 
          [ ky("Z"),ky("X"),ky("C"),ky("V"),ky("B"),
            ky("N"),ky("M"),
          ],
        ),
      ],
    );
  }

  Widget ky( String letter )
  { return Container
    ( decoration: BoxDecoration(border:Border.all(width:2)),
      width:50, height:40,
      child: ElevatedButton
      ( onPressed: (){ tec.text = tec.text + letter ; },
        child: Text( letter, style: TextStyle(fontSize: 16) ),
      ),
    );
  }
}
