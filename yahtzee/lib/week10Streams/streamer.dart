// Barrett Koster 2024
// demo of StreamBuilder, dummy stream

import 'package:flutter/material.dart';

import '../../widgets/bb.dart';

void main() 
{ runApp(const StreamDemo1());
}

class StreamDemo1 extends StatelessWidget
{
 const StreamDemo1({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "demo StreamBuilder",
      home: Scaffold
      ( appBar: AppBar( title: Text("demo StreamBuilder") ),
        body: Ping1(), 
      ),
    );
  }
}

class Ping1 extends StatelessWidget 
{ const Ping1({super.key});

  @override
  Widget build( BuildContext context )
  { 
    Stream<int> bob = countStream();
    
    return StreamBuilder
    ( stream: bob,
      builder: ( context, snapshot) 
      { if ( snapshot.hasData ) 
        { return BB("${snapshot.data!}");   }
        else
        { return Text("loading"); }
      }
    );

  }

  Stream<int> countStream() async*
  {
    for( int i=1; i>0; i++ )
    {
        await Future.delayed( Duration(milliseconds:2000) );
        yield i;
    }
  }

}


