// Barrett Koster
// This is supposed to be BOTH sides of a
//conversation between processes

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// flutter pub add socket_io
// flutter pub outdated
// flutter pub add socket_io_client
import '../../widgets/bb.dart';

import 'yak_server.dart';
import 'msg_state.dart';
import 'yak_client.dart';

void main()
{
  runApp(Yak());
}

class Yak extends StatelessWidget
{ Yak({super.key});
 
  @override
  Widget build(BuildContext context)
  { return MaterialApp
    ( title: 'Yak',
      home: Yak1(),
    );
  }
}

class Yak1 extends StatelessWidget
{ Yak1({super.key});

  @override
  Widget build(BuildContext context)
  { TextEditingController tec = TextEditingController();
    return Scaffold
    ( appBar: AppBar( title: Text("Yak"), ),
      body: Column
      ( children:
        [ ElevatedButton
          ( onPressed: ()
            { Navigator.of(context).push
              ( MaterialPageRoute
                ( builder: (context)
                  { return YakServer(); }
                ) 
              );
            },
            child: BB("server"),
          ),
          ElevatedButton
          ( onPressed: ()
            { Navigator.of(context).push
              ( MaterialPageRoute
                ( builder: (context)
                  { return YakClient( tec.text ); }
                ) 
              );
            },
            child: BB("client"),
          ),
          Container
          ( decoration: BoxDecoration( border: Border.all() ),
            child: SizedBox
            ( height: 50, width: 200,
              child: TextField
              (controller:tec, style:TextStyle(fontSize:25)), 
            ),
          ),
        ],
      ),
    );
  }
}
