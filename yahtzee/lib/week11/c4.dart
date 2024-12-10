// Barrett Koster
// hacking from comm pair I found on the internet.
// 

import 'dart:io';
import 'dart:typed_data';

void main() async
{
  String? where = 'localhost';
  where = stdin.readLineSync();


  // connect to the socket server
  final socket = await Socket.connect(where, 9201);
  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

  // listen for responses from the server
  socket.listen
  ( (Uint8List data)
    { final serverResponse = String.fromCharCodes(data);
      print('Server: $serverResponse');
    },

    onError: (error) {
      print(error);
      socket.destroy();
    },

    onDone: () {
      print('Server left.');
      socket.destroy();
    },
  );

  print("talk ('bye' to quit): ");
  String? sed = stdin.readLineSync();
  while (sed! != "bye")
  { // print("trying to send: $sed");
    await sendMessage(socket,sed);
    print("talk ('bye' to quit): ");
    sed = stdin.readLineSync();
  }
  await sendMessage(socket,sed); // has to be 'bye'
  exit(0);
}

Future<void> sendMessage(Socket socket, String message) async 
{ print('Client: $message');
  socket.write(message);
  await Future.delayed(Duration(seconds: 2));
}