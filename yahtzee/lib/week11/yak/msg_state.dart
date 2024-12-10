import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Msg 
{
  bool whoami; // true=server, false=client
  List<String> conversation;

  Msg( this.whoami, this.conversation);
}
class MsgCubit extends Cubit<Msg>
{
  MsgCubit(w) : super( Msg(w,["here we go ...","second line"]) );
  upi( String i )
  { List<String> theList = state.conversation;
    theList.add("${state.whoami?"server:":"client:"}$i");
    emit( Msg(state.whoami,theList) );
  }

  upu( String u )
  { List<String> theList = state.conversation;
    theList.add("${state.whoami?"client:":"server:"}$u");
    emit( Msg(state.whoami,theList) );
  }

  setRole( bool r ){ emit(Msg(r, state.conversation) ); }
}
