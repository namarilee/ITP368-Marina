import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:path_provider/path_provider.dart";


void mainFS() // FS
{ runApp( FileStuff () );
}

class FileStuff extends StatelessWidget
{
  FileStuff({super.key});

  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "file stuff - barrett",
      home: FileStuffHome(),
    );
  }
}

class FileStuffHome extends StatelessWidget
{
   FileStuffHome({super.key});

  @override
  Widget build( BuildContext context ) 
  { 
    Future<String> mainDirPath = whereAmI();

    String contents = readFile();
    writeFile();
    return Scaffold
    ( appBar: AppBar( title: Text("file stuff - barrett") ),
      body: Text(contents),
    );
  }

  Future<String> whereAmI() async
  {
    Directory mainDir = await getApplicationDocumentsDirectory();
    String mainDirPath = mainDir.path;
    print("mainDirPath is $mainDirPath");
    return mainDirPath;
  }
  
  String readFile()
  {
   // String myStuff = "/Users/marinalee/Desktop/itp368/yahtzee-Marina/yahtzee/lib/workFlutter.txt";
    //File another = File(myStuff);
   //print("ANOTHER: "+another.readAsStringSync());
    String filePath = "workFlutter.txt";
    File fodder = File(filePath);
    ///print("FILE READ@");
    if(!fodder.existsSync())
    {
      fodder.createSync();
    }
  // print("abs: " + fodder.absolute);
    String contents = fodder.readAsStringSync(); 
  //  print("content: "+contents);
    return contents;
  }

  void writeFile()
  { //String myStuff = "/Users/marinalee/Desktop/itp368/yahtzee-Marina/yahtzee/lib";
    String filePath = "otherStuff.txt";
    File fodder = File(filePath);
    fodder.writeAsStringSync("put this in the file");
  }
}