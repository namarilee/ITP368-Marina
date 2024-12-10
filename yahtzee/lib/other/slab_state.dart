// slab_state.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/rendering.dart';


class SlabState
{
  List<Path> strokes;
  Path aPath;

  SlabState( this.strokes, this.aPath )
  {
    // print( "======== |strokes|=${strokes.length}" );
  }
}

class SlabCubit extends Cubit<SlabState>
{
  SlabCubit() : super (  SlabState([], Path()) );

  void doInit(){ emit(SlabState( [], Path() ) ); }
  
  // gets called when you start a stroke.
  // Move the aPath pointer to the coordinates of ds.
  // Assume that a fresh Path already exists.
  //  Add this path to the strokes list, so that we can see it as we make it.
  void doStart( TapDownDetails ds )
  {
    // print("ds");
    state.aPath.moveTo(ds.localPosition.dx, ds.localPosition.dy );
    state.strokes.add(state.aPath);
    emit( SlabState(state.strokes, state.aPath ) );
  }

  // gets called when you move in the middle of a stroke.
  // Add to aPath a lineTo du coordinates.
  // Also do setState here so that we can see it as we draw it.
  void doMove( DragUpdateDetails du )
  {
    // print("du");
    state.aPath.lineTo(du.localPosition.dx, du.localPosition.dy );
    // setState( () {} );
    emit( SlabState(state.strokes, state.aPath ) );
  }
  // gets called when you pick your finger up from stroke.
  // You can add the lineTo if you want, but it's probably not needed.
  // Set aPath to new fresh Path  ready for next stroke.
  void doEnd( DragEndDetails de )
  {
    // print("de");
    // strokes.add(aPath); done at tap down.
    state.aPath = Path();
    // setState( () {} ); done for each move
    emit( SlabState(state.strokes, state.aPath ) );
  }
}