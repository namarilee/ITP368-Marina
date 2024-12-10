
import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'msg_state.dart';
import 'server_state.dart';
import 'client_state.dart';
import '../../widgets/bb.dart';

class YakServer extends StatelessWidget
{ YakServer({super.key});

  @override
  Widget build(BuildContext context)
  { return Scaffold
    ( appBar: AppBar( title: Text("YakServer"), ),
      body: BlocProvider<MsgCubit>
      ( create: (context) => MsgCubit(true),
        child: BlocProvider<ServerCubit>
        ( create: (context) => ServerCubit(),
          child: BlocProvider<ClientCubit>
          ( create: (context) => ClientCubit(),
            child: BlocBuilder<MsgCubit,Msg>
            ( builder: (context,state)
              { return BlocBuilder<ServerCubit,ServerState>
                ( builder: (context,state)
                  { return BlocBuilder<ClientCubit,ClientState>
                    ( builder: (context,state)
                      { return YakS2(); 
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class YakS2 extends StatelessWidget
{ YakS2({super.key});

  @override
  Widget build( BuildContext context ) 
  { MsgCubit mc = BlocProvider.of<MsgCubit>(context);
    ServerCubit sc = BlocProvider.of<ServerCubit>(context);
    ClientCubit cc = BlocProvider.of<ClientCubit>(context);

    // if the server cubit does not have a server socket, call it.
    //         and display 'loading'.
    // else (server socket exists) ...
    // if a client has not connected display 'waiting for client'
    // else display the box ready for messages
    if ( !sc.state.isSet )
    { sc.setup(mc,cc);
      return BB("server socket being created"); 
    }
    else
    { if ( !cc.state.isSet )
      { return BB("waiting for client to connect"); }
      else
      {
        Column c = Column(children:[]);
        for ( String s in mc.state.conversation )
        { c.children.add
          ( BB( s ),
          );
        }
        TextEditingController tec = TextEditingController();

        return Column
        ( children:
          [
            SingleChildScrollView
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
            ( onPressed: (){},
              child: BB("send it"),
            ),
          ]
        );
      }
    }
  }
}
