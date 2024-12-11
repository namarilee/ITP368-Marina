// Barrett Koster 2024
// demo of resizing

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../widgets/bb.dart';

void main() async
{ 
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions
  ( size: Size(350, 400),
    center: false,
    backgroundColor: Colors.yellow, // Colors.transparent,
    skipTaskbar: false,
    // titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow
  ( windowOptions, 
    () async 
    {
      // await Future.delayed( Duration(seconds: 2) );
      await windowManager.show();
      await windowManager.focus();
    }
  );

  runApp(const Resizer());
}


class Resizer extends StatelessWidget 
{ const Resizer({super.key});

  @override
  Widget build(BuildContext context) 
  { return  MaterialApp
    ( title: 'Resizer',
      home:  Resizer1(),
    );
  }
}

class Resizer1 extends StatelessWidget 
{ const Resizer1({super.key});

  @override
  Widget build(BuildContext context)
  { 
    print("Resizer1.build called ....");
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    List<BB> kids = [ BB("bob"),  BB("mary"), BB("jane"), ];

    return Scaffold
    (
      appBar: AppBar( title: Text("Resize"),  ),
      body: 
        width>500
        ? Row( children: kids )
        : Column( children: kids ),
    );
  }
}
