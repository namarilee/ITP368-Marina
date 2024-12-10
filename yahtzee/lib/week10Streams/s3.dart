// Barrett Koster
// working from notes from Suragch

// server side


import 'dart:io';
import 'dart:typed_data';


void main() async
{
  Socket? theClient;

  // bind the socket server to an address and port
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 9201);
  print("server socket created?");
  // listen for clent connections to the server
  server.listen((client) {
    handleConnection(client);
    theClient = client;
  });

  print("talk: ");
  String? sed = stdin.readLineSync();
  while (sed! != "quit")
  { 
    if ( theClient != null )
    { print("trying to send: $sed");
      await sendMessage(theClient!,sed);
    }
    else{ print("not ready");}
    print("talk: ");
    sed = stdin.readLineSync();
  }

  
}

void handleConnection(Socket client) {
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}');

  Socket theClient = client;
  // listen for events from the client
  client.listen(

    // handle data from the client
    (Uint8List data) async {
      // await Future.delayed(Duration(seconds: 1));
      final message = String.fromCharCodes(data);
      print("client: $message");
      if (message == 'Knock, knock.') {
        client.write('Who is there?');
      } else if (message.length < 10) {
        client.write('$message who?');
      } else {
        client.write('Very funny.');
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

Future<void> sendMessage(Socket socket, String message) async {
  print('Client: $message');
  socket.write(message);
  // await Future.delayed(Duration(seconds: 2));
}