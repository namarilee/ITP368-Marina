// Barrett Koster
// doing a stream reader type app (stream from net)
// Working from Grider's news app

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'newsItem.dart';
import '../widgets/bb.dart';
import 'news_item_page.dart';

void main()
{ runApp( News() ); }

class News extends StatelessWidget
{ News({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "news",
      home: Scaffold
      ( appBar: AppBar( title: Text("news") ),
        body: News1()
      ),
    );
  }
}

class News1 extends StatelessWidget
{ News1({super.key});

  @override
  Widget build( BuildContext context )
  { 
    // stream of just the numbers
    Stream<int> ts = topStream();
    List<int> all = [];

    // stream of news items, includes the headline
    Stream<NewsItem> sni = topStreamItems();
    List<NewsItem> allni = [];


    return StreamBuilder  
    ( stream: sni,
      builder: ( context, snapshot )     
      { Column c  = Column( children: [ Text("items")] );
        if (snapshot.hasData )
        { allni.add( snapshot.data! ); }
        else { return BB("loading"); } 
        for ( NewsItem ni in allni )
        { 
          c.children.add
          ( Row
            ( children:
              [ Text('${ni.id}'),
                // Text(ni.headline),
                ElevatedButton
                ( onPressed: ()
                  { Navigator.push
                    ( context, 
                      MaterialPageRoute
                      ( builder: (context)
                        { return NewsItemPage( ni.id ); }
                      ) 
                    );
                  },
                  child: Text(ni.headline),
                ),
              ],
            )
          );
        }
        return c;
      },
    );
  }

  // return the top news story numbers as a stream
  Stream<int> topStream() async*
  {
    List<int> topList = await getTopNumbers();
    for( int sn in topList )
    {
        await Future.delayed( Duration(milliseconds:2000) );
        yield sn;
    }
  }

  // returns the top news stories as a stream
  Stream<NewsItem> topStreamItems() async*
  { String root = "https://hacker-news.firebaseio.com/v0/";
    List<int> topList = await getTopNumbers();
    for ( int sn in topList )
    {
      final url = Uri.parse('${root}item/${sn}.json');
      final response = await http.get(url);
      Map<String,dynamic> theItem = jsonDecode(response.body);
      NewsItem ni = NewsItem.fromJson( theItem );
      yield ni;
    }
  }



  // fetches an image url from a website.  Takes a while,
  // so we mark it 'async' and it returns a Future.
  Future<List<int>> getTopNumbers() async
  { String root = "https://hacker-news.firebaseio.com/v0/";
    // await Future.delayed( Duration(milliseconds:2000) );
    final url = Uri.parse('${root}topstories.json');
    final response = await http.get(url);
    List<dynamic> dataList = jsonDecode(response.body);
    // print(dataList);
    List<int> topList = [];
    for ( int i=0; i<15; i++ )
    {
        topList.add( dataList[i] );
    }
    print(topList);
    // for ( String k in dataAsMap.keys )
    // { print("k=$k"); }

    return topList;
  }

}
