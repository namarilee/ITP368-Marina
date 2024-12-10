// Barrett Koster
// client_cl is a command line client (attempt)

import 'dart:io';
import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// flutter pub add socket_io
// flutter pub add socket_io_client
// flutter pub outdated

void main()
{
  // String host = "http://localhost";
  String host = "http://172.20.1.160";
  // String host = "http://0.0.0.0";

  IO.Socket socket = IO.io
  ( "${host}:37894",
    <String, dynamic>
    { 'transports': ['websocket'], 'autoConnect': false, }
  /*   IO.OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .disableAutoConnect()  // disable auto-connection
      .setExtraHeaders({'foo': 'bar'}) // optional
      .build()
  */
  );
  socket.onConnect
  ((_)  { print('Connected to the socket server');
          socket.emit('msg','test');
        }
  );
  socket.onDisconnect( (_)   { print('Disconnected');  } );
  socket.on('fromServer', (_) => print(_));
  socket.on('message', (data) { print('got: $data');  });
  socket.connect(); // use if autoconnect:false


  print("talk: ");
  String? sed = stdin.readLineSync();
  while (sed! != "quit")
  { print("trying to send: $sed");
    print("talk: ");
    sed = stdin.readLineSync();
    socket.emit('msg',"client said: $sed");
  }
}
