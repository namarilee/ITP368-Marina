// Barrett Koster 2024

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// from command line> flutter pub add http
// > flutter pub add flutter_bloc

import 'weather_model.dart';

import '../widgets/bb.dart';

void mainWeather2() // Weather2
{ runApp(const WeatherPage());
}

class WeatherPage extends StatelessWidget
{
 const WeatherPage({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "weather demo",
      home: Scaffold
      ( appBar: AppBar( title: Text("weather demo") ),
        body: BlocProvider<WeatherCubit>
        ( create: (context) => WeatherCubit(),
          child: BlocBuilder<WeatherCubit,WeatherModel>
          ( builder: (context,state)
            { return Weather1(); }
          ),
        ),
      ),
    );
  }
}

class Weather1 extends StatelessWidget 
{ const Weather1({super.key});

  @override
  Widget build( BuildContext context )
  { WeatherCubit wc = BlocProvider.of<WeatherCubit>(context);
    TextEditingController tec = TextEditingController();

    return Column
    ( children:
      [ Row
        ( children:
          [ BB("city "),
            BB(wc.state.cityName),
          ],
        ), 
        Row
        ( children:
          [ BB("temp C"),
            BB("${wc.state.temperature}"),
          ],
        ),
        Row
        ( children:
          [ BB("wind speed kph"),
            BB("${wc.state.windSpeed}"),
          ],
        ),
        Row
        ( children:
          [ BB("wind direction"),
            BB(wc.state.windDir),
          ],
        ),
        Row
        ( children:
          [ BB("zip "),
            SizedBox
            ( height: 90, width: 200,
              child: TextField 
              ( controller:tec, 
                style:TextStyle( fontSize: 30)
              ), 
            ),

            ElevatedButton
            ( onPressed: () async  {  wc.update(tec.text); },
              child: BB("update"),
            ),
          ],
        ),
      ],
    );
  }


}
