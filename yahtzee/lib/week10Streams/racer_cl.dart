// Barrett Koster 2024
// demo of racing, dart command line
// > dart racer_cl.dart alice
// or bob or whoever, that name will be printed in a 
// randomly delayed count to 10.
// This can be run in separate windows at the same time.

import 'dart:math';
// import 'package:flutter/material.dart';

void main( List<String> args) async
{ 
  String name = "bob";
  if ( args.length>0 )
  { name = args[0]; }
  countStream(name); // keeps runing after main ends
}

  // Stream<int> countStream( String s ) async*
Future<void> countStream( String s ) async
{
  Random randy = Random();

  for( int i=1; i<10; i++ )
  {
    int howMuch = randy.nextInt(500) + 300;
    await Future.delayed( Duration(milliseconds:howMuch) );
    print("$s says $i");
      // yield i;
  }
}

