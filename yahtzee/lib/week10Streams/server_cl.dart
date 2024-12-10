// Barrett Koster
// server_cl.dart
// trying to do a socket server from command line

import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// flutter pub add socket_io
// flutter pub outdated
// flutter pub add socket_io_client

void main()
{
  print("server_cl starting ...");

  var io = Server();
  var nsp = io.of("/some");
  nsp.on
  ( "connection",(client)
    { print("a client connected on nsp");
      client.on
      ( 'msg',  (data) 
                { print('data from /some => $data');
                  client.emit('fromServer', "ok 2");
                }
      );
    }
  );
  io .on
  ( "connection",(client)
    { print("a client connected on io");
      client.on
      ( 'msg',  (data)
                { print("$data was said (default?)"); 
                  client.emit('fromServer',"ok");
                }
      );
    }
  );
  io.listen(37894);
}

