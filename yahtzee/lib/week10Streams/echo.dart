// Barrett Koster 2024

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
// from command line> flutter pub add http
// > flutter pub add flutter_bloc
// > flutter pub add http
// > flutter pub add web_socket_channel

import '../widgets/bb.dart';

void mainEcho() // Echo
{ runApp(const EchoDemo());
}

// holds outgoing and incoming messages
class MsgState
{ String saidI;
  String saidYou;
  MsgState( this.saidI, this.saidYou );
}
class MsgCubit extends Cubit<MsgState>
{ MsgCubit() : super( MsgState("Hey.","What?") );

  void updateI(String m) { emit(MsgState(m,state.saidYou)); }
  void updateYou(String m) { emit(MsgState(state.saidI,m)); }
}

class EchoDemo extends StatelessWidget 
{ const EchoDemo({super.key});

  @override
  Widget build(BuildContext context)
  { return MaterialApp
    ( title: 'Echo Demo',
      home:  BlocProvider<MsgCubit>
      ( create: (context) => MsgCubit(),
        child: BlocBuilder<MsgCubit,MsgState>
        ( builder: (context, state)
          { return EchoHome(); }
        ),
      ),
    );
  }
}

class EchoHome extends StatelessWidget 
{ const EchoHome({super.key});

  @override
  Widget build(BuildContext context)
  { MsgCubit mc = BlocProvider.of<MsgCubit>(context);

    final channel = WebSocketChannel.connect
    ( Uri.parse('wss://echo.websocket.events'), );

    TextEditingController tec = TextEditingController();

    return Scaffold
    (
      appBar: AppBar( title: const Text("echo"),  ),
      body:  Column
      ( children:
        [ BB("me"),
          BB(mc.state.saidI),
          SizedBox
          ( height: 50, width: 200,
            child: TextField
            ( controller: tec, style: TextStyle(fontSize:30) ),
          ),
          ElevatedButton
          ( onPressed: () 
            { String s = tec.text;
              channel.sink.add(s);
            },
            child: BB("tell"),
          ),
          BB(mc.state.saidYou),
          BB("stream"),
          StreamBuilder
          ( stream: channel.stream,
            builder: (context,snapshot)
            { 
              // infinite loop:
              // if ( snapshot.hasData ) 
              // { mc.updateYou( snapshot.data ); }
              return Text
              ( snapshot.hasData
                ? '${snapshot.data}' 
                : 'loading'
              );
            }
          ),
        ],
      ),



/* StreamBuilder
      ( stream: channel.stream,
        builder: (context)
        { return Pinger("bob"); },
      ),
*/
    );
  }

  Future<String> _networkCall() async
  {
    final url = Uri.parse('https://reqres.in/api/users/2');
    final response = await http.get(url);
    Map<String,dynamic> dataAsMap = jsonDecode(response.body);
    // print(dataAsMap);
    // for ( String k in dataAsMap.keys )
    // { print("k=$k"); }
    Map<String,dynamic> dig1 = dataAsMap['data'];
    String imgurl = dig1['avatar'];
    print("imgurl=$imgurl");
    return imgurl;
  }

}

class Pinger extends StatelessWidget
{ final String name;
  Pinger(this.name, {super.key});

  @override
  Widget build( BuildContext context )
  { 
    return Column
    ( children:
      [ BB(name),
        BB("message" ),
        ElevatedButton
        ( onPressed: (){},
          child: BB("push me"),
        ),
      ],
    );
  }
}

