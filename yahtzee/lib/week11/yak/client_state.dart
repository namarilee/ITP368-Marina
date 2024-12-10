import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'msg_state.dart';


class ClientState
{
  Socket? client;
  bool isSet = false;

  ClientState();
  ClientState.set(this.client);
}

class ClientCubit extends Cubit<ClientState>
{
  ClientCubit(): super( ClientState() );

  // This 1-arg version of got is for generatine responses to
  // incomding messages
  void got( String s )
  {
    /*              if (message=="hi")
              { client.write("hi, back"); }
              else if (message=="bye")
              { client.write('ok, bye');
                client.close();
              } */
  }

  Future<void> setup( MsgCubit mc, String serverID) async
  {
    if (!state.isSet)
    { state.isSet = true; // only runs once
      // connect to the socket server
      final socket = await Socket.connect(serverID, 9201);
      mc.upi('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
      

      // listen for responses from the server
      socket.listen
      ( (Uint8List data)
        { final serverResponse = String.fromCharCodes(data);
          mc.upu(serverResponse);
        },

        onError: (error) {
          mc.upi(error);
          socket.destroy();
        },

        onDone: () {
          mc.upi('Server left.');
          socket.destroy();
          emit( ClientState() );
        },
      );
      emit( ClientState.set(socket) );
    }
  }
  
  Future<void> sendMessage(Socket socket, String message) async 
  { print('Client: $message');
    socket.write(message);
    await Future.delayed(Duration(seconds: 2));
  }

}