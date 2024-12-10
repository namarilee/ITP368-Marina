// Barrett Koster 2024
// demo of pinging a database of images

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
// from command line> flutter pub add http
// > flutter pub add flutter_bloc
// > flutter pub add http
// > flutter pub add web_socket_channel

import '../widgets/bb.dart';

void main() // PingLob
{ runApp(const PingLob());
}

// just holds a string.  In Ping1, it is the URL of a 
// picture.
class MsgState
{ String msg;
  MsgState( this.msg );
}
class MsgCubit extends Cubit<MsgState>
{ MsgCubit() : super( MsgState("zip") );
  MsgCubit.s(String s ) : super( MsgState(s));
  void update(String m) { emit(MsgState(m)); }
}

class PingLob extends StatelessWidget
{
 const PingLob({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "Ping Lob",
      home: Scaffold
      ( appBar: AppBar( title: Text("Ping Lob") ),
        body: Row
        ( children:
          [ Ping1(),
          ],
        ),
      ),
    );
  }
}

class Ping1 extends StatelessWidget 
{ const Ping1({super.key});

  @override
  Widget build( BuildContext context )
  { String imgurl; // = "https://reqres.in/img/faces/3-image.jpg";
    return BlocProvider<MsgCubit>
    ( create: (context) 
        => MsgCubit.s("https://reqres.in/img/faces/3-image.jpg"),
      child: BlocBuilder<MsgCubit,MsgState>
      ( builder: (context, state)
        { return Builder
          ( builder: (context)
            { MsgCubit mc = BlocProvider.of<MsgCubit>(context);
              imgurl = mc.state.msg;
              return Column
              ( children:
                [ ElevatedButton
                  ( onPressed: () async 
                    { imgurl = await _networkCall(2);
                      await Future.delayed( Duration(milliseconds:2000) );
                      mc.update(imgurl);
                    },
                    child: BB("pic 2"),
                  ),ElevatedButton
                  ( onPressed: () async 
                    { imgurl = await _networkCall(4);
                      await Future.delayed( Duration(milliseconds:2000) );
                      mc.update(imgurl);
                    },
                    child: BB("pic 4"),
                  ),
                  Image.network(imgurl),
                ],
              ); 
            },
          );
        },
      ),
    );
  }

  Future<String> _networkCall(int x) async
  {
    final url = Uri.parse('https://reqres.in/api/users/$x');
    final response = await http.get(url);
    Map<String,dynamic> dataAsMap = jsonDecode(response.body);
    print(dataAsMap);
    // for ( String k in dataAsMap.keys )
    // { print("k=$k"); }
    Map<String,dynamic> dig1 = dataAsMap['data'];
    String imgurl = dig1['avatar'];
    // print("imgurl=$imgurl");
    return imgurl;
  }
}
