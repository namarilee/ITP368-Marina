import "dart:io";
import "dart:math";
import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
// import "package:path_provider/path_provider.dart";

TextStyle ts = TextStyle(fontSize: 30);

class QAPair
{ String question;
  String answer;

  QAPair( this.question, this.answer );
}
class DataState
{
  List<QAPair> theData = [];

  DataState( )
  {
    String myStuff = "C:\\Users\\Barry-Standard\\Documents\\courses\\USC\\ITP-368\\workFlutter";
    String filePath = "$myStuff/StateCapitals.txt";
    File dataFile = File(filePath);
    // String contents = dataFile.readAsStringSync();
    List<String> lines = dataFile.readAsLinesSync(encoding : utf8);

    int count = 0;
    for ( String line in lines )
    { if (count++>0 )
      { addLine(line); }
    }

    /* streaming ... not needed this time
    dataFile.openRead()
      .transform(utf8.decoder)
      .transform( LineSplitter() )
      .forEach( (line) { addLine(line); });
    */
  }

  // input: string which is question,answer
  // eg. Ohio,Columbus
  // add this qa pair to theData.
  void addLine( String qa )
  { List<String> parts = qa.split(",");
    QAPair qap = QAPair( parts[0], parts[1] );
    theData.add(qap);
    print("added to data ${parts[0]} ${parts[1]}");
  }

  DataState.already( this.theData );
}

class DataCubit extends Cubit<DataState>
{
  DataCubit() : super( DataState() );
}

class ScoreState
{
  int numTried;
  int numCorrect;
  String feedback;

  ScoreState(this.numTried,this.numCorrect, this.feedback);
}
class ScoreCubit extends Cubit<ScoreState>
{
  ScoreCubit() : super( ScoreState(0,0,"nothing") );

  void gotit()
  { emit
    ( ScoreState
      ( state.numTried+1, state.numCorrect+1, 
        "you got it"
      )
    ); 
  }
  void missed( String correction)
  { emit
    ( ScoreState
      ( state.numTried+1, state.numCorrect, 
        correction
      )
    ); 
  }
}


void mainQ1() // Q1
{ runApp( Quiz1 () );
}

class Quiz1 extends StatelessWidget
{
  Quiz1({super.key});

  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "Quiz1- barrett",
      home: Quiz1Home(),
    );
  }
}

class Quiz1Home extends StatelessWidget
{
   Quiz1Home({super.key});

  @override
  Widget build( BuildContext context ) 
  { return Scaffold
    ( appBar: AppBar( title: Text("Quiz1 - barrett") ),
      body: BlocProvider<DataCubit>
      ( create: (context) => DataCubit(),
        child: BlocBuilder<DataCubit,DataState>
        ( builder: (context,state)
          { return BlocProvider<ScoreCubit>
            ( create: (context) => ScoreCubit(), 
              child: BlocBuilder<ScoreCubit,ScoreState>
              ( builder: (context, state)
                { return QuizPage(); }
              )
            );
          }
        ),
      ),
    );
  }
}

class QuizPage extends StatelessWidget
{
  @override
  Widget build( BuildContext context )
  {
    DataCubit datCubit = BlocProvider.of<DataCubit>(context);
    DataState dataState = datCubit.state;

    ScoreCubit scoreCubit = BlocProvider.of<ScoreCubit>(context);
    ScoreState scoreState = scoreCubit.state;
    

    List<QAPair> theData = dataState.theData;
    Random randy = Random();
    int le = theData.length;
    // print("le=$le");
    int which = randy.nextInt(le);
    QAPair theQA = theData[which];
    String question = theQA.question;
    String answer = theQA.answer;
    TextEditingController tec = TextEditingController();
    
    return Column
    ( children:
      [ Text("hint:  $answer", style:ts),
        Text("question: $question", style:ts),
        Text
        ( "${scoreState.numCorrect} of ${scoreState.numTried}",
          style:ts,
        ),
        
        Row
        ( children: 
          [ Text("answer here:", style:ts),
            TextFormField(controller:tec, style:ts),
          ],
        ),
        
        ElevatedButton
        ( onPressed: ()
          { String guess = tec.text;
            if ( guess == answer ) { scoreCubit.gotit(); }
            else { scoreCubit.missed("answer was $answer"); }
          },
          child: Text("submit", style:ts),
        ),
      ],
    );
  }
}