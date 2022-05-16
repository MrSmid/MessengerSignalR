import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String chatURL = "http://10.0.2.2:5000/messagehub";
  late HubConnection hubConnection;

  int messagesNum = 3;
  List<String> messages = ["сообщение 1", "сообщение 2", "сообщение 3"];
  String newMessage = '';

  @override
  void initState() {
    super.initState();
    initSignalR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Container(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return _getListMessages(index, messages);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black,),
              itemCount: messagesNum,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: FloatingActionButton(
                    child: Icon(hubConnection.state == HubConnectionState.Connected ? Icons.stop : Icons.play_arrow),
                    onPressed: () {
                        setState(() async {
                          hubConnection.state == HubConnectionState.Connected ? await hubConnection.stop() : await hubConnection.start();
                        });
                      },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    onChanged: (String message){
                      newMessage = message;
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    child: Text("Отправить"),
                    onPressed: () async {
                      if (hubConnection.state == HubConnectionState.Connected){
                        await hubConnection.invoke("SendNewMessage", args: <Object>[newMessage]);
                      }
                      setState(() {
                        messages.add(newMessage);
                        messagesNum++;
                      });
                    },
                ),
                )
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _getListMessages(int index, List<String> messagesData){
    return GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  child: Text(messagesData[index], style: TextStyle(fontSize: 20),)
              ),
            ],
          ),
        )
    );
  }

  void initSignalR() {
    hubConnection = HubConnectionBuilder()
        .withUrl(chatURL)
        .build();
    hubConnection.onclose((error) => {print("Connection close by error: ${error}")});
    hubConnection.on("ReceiveNewMessage", _handleNewMessage);
  }

  _handleNewMessage(List<Object> args) {
    setState(() {
      messages.add(args[0].toString());
      messagesNum++;
    });
  }
}

