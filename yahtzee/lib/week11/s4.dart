// Barrett Koster
// hacking from 

import 'dart:io';
import 'dart:typed_data';

// in https://github.com/professorprism/comm

void main() async
{ 
  // bind the socket server to an address and port
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 9201);
  print("server socket created?");
  // listen for clent connections to the server
  server.listen((client) {
    handleConnection(client);
    // converse( client );
  });
}

// waits for user to type in THIS window and sends it
// to the client window.
Future<void> converse( Socket socket) async
{
  // print("talk ('bye' to quit): ");
  stdout.write("server: ");
  String? sed = stdin.readLineSync();
  while (sed! != "bye")
  { // print("trying to send: $sed");
    await 
    sendMessage(socket,sed);
    // print("talk ('bye' to quit): ");
    stdout.write("server: ");
    sed = stdin.readLineSync();
  }
  await sendMessage(socket,sed); // has to be 'bye'
  socket.close();
  exit(0);

}

Future<void> sendMessage(Socket socket, String message) async 
{ print('Server: $message');
  socket.write(message);
  // socket.flush();
  await Future.delayed(Duration(seconds: 2));
}

void handleConnection(Socket client)
{
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}');

  // listen for events from the client
  client.listen
  ( (Uint8List data) async 
    {
      final message = String.fromCharCodes(data);
      print("client: $message");
      // await Future.delayed(Duration(seconds: 1));
      if (message=="hi")
      { client.write("hi, back"); }
      else if (message=="bye")
      { client.write('ok, bye');
        client.close();
      } 
    },

    // handle errors
    onError: (error) {
      print(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () {
      print('Client left');
      client.close();
    },
  );
}