import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:path_provider/path_provider.dart";


void mainGr() // FS
{ runApp( FileStuff () );
}

class FileStuff extends StatelessWidget
{
  FileStuff({super.key});

  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "grocery list - marina",
      home: FileStuffHome(),
    );
  }
}

class FileStuffHome extends StatefulWidget {
  @override
  FileStuffHomeState createState() => FileStuffHomeState();
}

class FileStuffHomeState extends State<FileStuffHome> {
  TextEditingController tec = TextEditingController();
  String filePath = '';

  @override
  void initState() {
    super.initState();
    _getFilePath().then((path) {
      setState(() {
        filePath = path;
      });
      readFile(); // Load the saved content when the app starts
    });
  }

  Future<String> _getFilePath() async {
    Directory dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/grocery_list.txt';
  }


  @override
  Widget build( BuildContext context ) 
  { 
    
    return Scaffold
    ( appBar: AppBar( title: Text("grocery list - marina") ),
      body:  Column( 
        children: [ 
          TextField
          ( controller: tec, maxLines: null ),
          FloatingActionButton
          ( onPressed: ()
            { 
              writeFile();
            },
            child: Text("save"),
          ),
        ],
      ),
    );
  }

  Future<String> whereAmI() async
  {
    Directory mainDir = await getApplicationDocumentsDirectory();
    String mainDirPath = mainDir.path;
    print("mainDirPath is $mainDirPath");
    return mainDirPath;
  }
  
  void readFile() async {
    File file = File(filePath);
    if (await file.exists()) {
      String contents = await file.readAsString();
      setState(() {
        tec.text = contents;
      });
    }
  }

  void writeFile() async {
    File file = File(filePath);
    await file.writeAsString(tec.text);
  }
 
}