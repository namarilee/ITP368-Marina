// Barrett Koster
// line for github test

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// flutter pub add socket_io
// flutter pub outdated

void main()
{
  runApp(Yak());
}

class Msg 
{
  String ised;
  String used;
  Msg( this.ised, this.used );
}
class MsgCubit extends Cubit<Msg>
{
  MsgCubit() : super( Msg("yeah","what") );
  void upi( String i ) { emit( Msg(i,state.used) ); }
  void upu( String u ) { emit( Msg(state.ised,u) ); }
}


class Yak extends StatelessWidget
{ Yak({super.key});

  @override
  Widget build(BuildContext context)
  { return MaterialApp
    ( title: 'Yak',
      home: Scaffold
      ( appBar: AppBar( title: Text("Yak"), ),
        body: BlocProvider<MsgCubit>
        ( create: (context) => MsgCubit(),
          child: BlocBuilder<MsgCubit,Msg>
          ( builder: (context,state)
            { return Yak2(); },
          ),
        ),
      ),
    );
  }
}

class Yak2 extends StatelessWidget
{ Yak2({super.key});

  @override
  Widget build( BuildContext context )
  { 
            IO.Socket socket = IO.io
            ( "http://10.23.147.52:37894",
              <String, dynamic>
              { 'transports': ['websocket'], 'autoConnect': false, }
            );
            socket.onConnect
            ((_)  { print('Connected to the socket server');
                  }
            );
            socket.onDisconnect((_) {
              print('Disconnected from the socket server');
            });
            socket.connect();

    MsgCubit mc = BlocProvider.of<MsgCubit>(context);
    return Column
    ( children: 
      [ Text("Yakking"),
        Text(mc.state.ised),
        Text(mc.state.used),
        ElevatedButton
        ( onPressed: ()
          { 
            socket.emit("msg","hi");
          },
          child: Text("client try msg"),
        ),
      ],
    );
  }
}