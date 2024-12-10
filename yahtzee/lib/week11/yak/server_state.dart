// server_state.dart
// holds the ServerSocket when that gets set.


import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'msg_state.dart';
import 'client_state.dart';


class ServerState
{
  ServerSocket? ss;
  bool isSet = false; // false until we get it set

  ServerState(); // default state does nothing; server is NOT set yet.

  ServerState.set(this.ss) : isSet=true;
}

class ServerCubit extends Cubit<ServerState>
{
  ServerCubit() : super( ServerState() );

  Future<void> setup( MsgCubit mc, ClientCubit cc) async
  {
    if (!state.isSet)
    {
      await Future.delayed( Duration(seconds:4));
      final server = await ServerSocket.bind(InternetAddress.anyIPv4, 9201);
      mc.upi("server socket created");
      // listen for clent connections to the server
      server.listen
      ( (client)
        { mc.upi('Connection from'
            ' ${client.remoteAddress.address}:${client.remotePort}');

          // listen for events from the client
          client.listen
          ( (Uint8List data) async 
            {
              final message = String.fromCharCodes(data);
              mc.upu(message);

// at this point, think we want to send any message to the
// cc update.  
              // cc.got(message);
            },

            // handle errors
            onError: (error) {
              mc.upu(error);
              client.close();
            },

            // handle the client closing the connection
            onDone: ()
            { mc.upi('Client left');
              client.close();
            },
          );
        }
      );
      emit( ServerState.set(server) );
    } // end if
  } // end setup()
} // end class ServerCubit

