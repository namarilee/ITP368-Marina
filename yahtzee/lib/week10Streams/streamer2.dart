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
    print("build call");

    List<int> all = [];
     
    return StreamBuilder
    ( stream: bob,
      builder: ( context, snapshot) 
      {    Column c = Column(children: [ Text("0"), ] );

        if ( snapshot.hasData ) 
        { all.add(snapshot.data!);   
          print("trying to add ...${snapshot.data!}");
        }
        for ( int i in all )
        {
          c.children.add( Text("$i"));
        }
        return c;
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


