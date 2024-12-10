// Barrett Koster
// sound_board.dart
// hack the sound demo to hold 5 rows

// > flutter pub add record
// > flutter pub add just_audio

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sb_state.dart';

void main()
{ runApp(const SayWhat());
}

class SayWhat extends StatelessWidget
{ const SayWhat({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  { return MaterialApp
    ( title: "Sound Board (Barry's)",
      home: Scaffold
      ( appBar: AppBar(),
        body: Column
        ( children: 
          [ SayWhat1(id:"alvin"),
            SayWhat1(id:"betty"),
            SayWhat1(id:"chaz"),
            SayWhat1(id:"daria"),
            SayWhat1(id:"emmi"),
          ],
        ),
      ),
    );
  }
}

class SayWhat1 extends StatelessWidget
{ final String id;
  const SayWhat1({super.key, required this.id});

  @override
  Widget build(BuildContext context)
  { return BlocProvider<SoundCubit>
    ( create: (context) => SoundCubit(id),
      child: BlocBuilder<SoundCubit,SoundState>
      ( builder: (context,state)
        { return Builder
          ( builder: (context)
            { SoundCubit sc = BlocProvider.of<SoundCubit>(context);
              return Row
              ( children: 
                [ Text("$id"),
                  sc.state.isRecording
                  ? ElevatedButton
                    ( onPressed: (){ sc.stopRecording(); },
                      child: Text("stop rec"),
                    )
                  : ElevatedButton
                    ( onPressed: (){ sc.startRecording(); },
                      child: Text("record"),
                    ),
                
                  ElevatedButton
                  ( onPressed: (){ sc.playRecording(); },
                    child: Text("play"),
                  ),
                  ElevatedButton
                  ( onPressed: (){ sc.stopPlaying(); },
                    child: Text("stop play"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }


}
