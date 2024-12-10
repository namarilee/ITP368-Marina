import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// flutter pub add socket_io
// flutter pub outdated
// flutter pub add socket_io_client

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
  upi( String i ) { emit( Msg(i,state.used) ); }
  upu( String u ) { emit( Msg(state.ised,u) ); }
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
  { MsgCubit mc = BlocProvider.of<MsgCubit>(context);

    var io = Server();
    var nsp = io.of("/some");
    nsp.on
    ( "connection",(client)
      { print("something happened");
        // mc.upu(client); 
      }
    );
    io .on
    ( "connection",(client)
      { print("something else happened");
        client.on
        (
          'msg', (data)
          { mc.upu(data); }
        );

        //mc.upu(client); 
      }
    );
    io.listen(37894);

    return Column
    ( children:
      [ Text("Yakking"),
        Text(mc.state.ised),
        Text(mc.state.used),
      ],
    );
  }
}

