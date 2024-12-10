// Barrett Koster 2024
// demo of pinging a database of images
// uses FutureBuilder

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
// from command line> flutter pub add http
// > flutter pub add flutter_bloc
// > flutter pub add http
// > flutter pub add web_socket_channel

import '../widgets/bb.dart';

void main() 
{ runApp(const PingFB());
}

class SCubit extends Cubit<String>
{
   SCubit(String s) : super( s );
   void update( String s ) { emit( s ); }
}

class PingFB extends StatelessWidget
{
 const PingFB({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "Ping with FutureBuilder",
      home: Scaffold
      ( appBar: AppBar( title: Text("Ping with FutureBuilder") ),
        body: BlocProvider<SCubit>
        ( create: (context) => SCubit("3"),
          child: BlocBuilder<SCubit,String>
          ( builder: (context,state) => Ping1(), )
        )
      ),
    );
  }
}

class Ping1 extends StatelessWidget 
{ const Ping1({super.key});

  @override
  Widget build( BuildContext context )
  { SCubit sc = BlocProvider.of<SCubit>(context);
    
    Future<String> imgurl = _networkCall(sc.state);
    return Column
    ( children:
      [ ElevatedButton
        ( onPressed: () { sc.update("2");  },
          child: BB("pic 2"),
        ),ElevatedButton
        ( onPressed: () { sc.update("4");  },
          child: BB("pic 4"),
        ),
        FutureBuilder
        ( future: imgurl,
          builder: ( context, snapshot) 
          { if ( snapshot.hasData ) 
            { return Image.network(snapshot.data!);   }
            else
            { return Text("loading"); }
          }
        ),
      ],
    ); 
  }

  // fetches an image url from a website.  Takes a while,
  // so we mark it 'async' and it returns a Future.
  Future<String> _networkCall(String x) async
  {
    await Future.delayed( Duration(milliseconds:2000) );
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
