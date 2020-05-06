import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(
      MaterialApp(home: MyApp()),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Localhost for android - 10.0.2.2
  // Localhost for iOS - 127.0.0.1
  final IOWebSocketChannel channel =
      IOWebSocketChannel.connect('ws://150.136.56.131:5000');

  var userInput;
  List messages = [];

  send2WebSocket() {
    channel.sink.add(userInput);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                // The data is being pulled from the websocket
                messages.add(snapshot.data);
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Text('${messages[index]}');
                      });
                } else {
                  return Center(
                      child: Text('No messages yet, start typing...'));
                }
              },
            ),
          ),
          FlatButton.icon(
              onPressed: () {
                send2WebSocket();
              },
              icon: Icon(Icons.send),
              label: Text("send")),
          TextField(
            onChanged: (value) {
              userInput = value;
            },
          ),
        ],
      ),
    );
  }
}
