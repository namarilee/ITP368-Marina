

import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'msg_state.dart';
import 'server_state.dart';
import 'client_state.dart';

import '../../widgets/bb.dart';


class YakClient extends StatelessWidget
{
  final serverID;
  YakClient( this.serverID,{super.key});

  @override
  Widget build(BuildContext context)
  { return Scaffold
    ( appBar: AppBar( title: Text("YakClient"), ),
      body: BlocProvider<MsgCubit>
      ( create: (context) => MsgCubit(false),
        child: BlocProvider<ClientCubit>
        ( create: (context) => ClientCubit(),
          child: BlocBuilder<MsgCubit,Msg>
          ( builder: (context,state)
            { return BlocBuilder<ClientCubit,ClientState>
              ( builder: (context,state)
                { return YakC2(serverID); },
              );
            },
          ),
        ),
      ),
    );
  }
}

class YakC2 extends StatelessWidget
{
  final String serverID;
  YakC2( this.serverID, {super.key});

  @override
  Widget build( BuildContext context ) 
  { MsgCubit mc = BlocProvider.of<MsgCubit>(context);
    ClientCubit cc = BlocProvider.of<ClientCubit>(context);
    TextEditingController tec = TextEditingController();
  
    // if there is no client connection yet,
    //    print "trying to connect" and call setup().
    // else (there IS a client connection)
    //    display the conversation as a place to say more.
    if ( !cc.state.isSet ) // if no client connection 
    { cc.setup(mc,serverID); // try to connect, and
      return BB("trying to connect to server"); // display 'trying...'
    }
    else // there IS a client connection 
    {    // show conversation and place to type more
      Column c = Column(children:[]);
      for ( String s in mc.state.conversation )
      { c.children.add
        ( BB( s ),
        );
      }
      return Column
      ( children:
        [ SingleChildScrollView
          ( child: c,
          ),
          Container
          ( decoration: BoxDecoration( border: Border.all() ),
            child: SizedBox
            ( height: 50, width: 200,
              child: TextField
              (controller:tec, style:TextStyle(fontSize:25)), 
            ),
          ),
          ElevatedButton
          ( onPressed: ()
            { String msg = tec.text;
              mc.upi(msg); 
              // sendMessage( , msg );
            },
            child: BB("client send"),
          )
        ],
      );
    }
  }
}