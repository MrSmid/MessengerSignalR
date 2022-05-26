import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_signal_r/Model/messages_response.dart';
import 'package:messenger_signal_r/Model/token_response.dart';
import 'package:messenger_signal_r/constants.dart';
import 'package:messenger_signal_r/storage/secure_storage.dart';
import 'package:signalr_client/http_connection_options.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';

class ChatPage extends StatefulWidget {
  List<Messages> _messages;
  String _currentUsername;
  String _roomName;
  int _roomID;
  ChatPage(this._messages, this._currentUsername, this._roomName, this._roomID, {Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState(_messages, _currentUsername, _roomName, _roomID);
}

class _ChatPageState extends State<ChatPage> {
  late HubConnection hubConnection;
  List<Messages> _messagesObjects;
  String _currentUsername;
  String _roomName;
  int _roomID;
  List<String> messages = [];
  List<String> usernames = [];
  String newMessage = '';

  _ChatPageState(this._messagesObjects, this._currentUsername, this._roomName, this._roomID) : super(){
    for(int i = 0; i < _messagesObjects.length; i++) {
      messages.add(_messagesObjects[i].text ?? "message");
      usernames.add(_messagesObjects[i].username ?? "");
    }
  }

  @override
  void initState() {
    initSignalR();
    super.initState();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        centerTitle: true,
      ),
      backgroundColor: Color(BGcolor),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: Text(
                _roomName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
          Expanded(
            flex: 30,
            child: Container(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return _getListMessages(index);
                },
                itemCount: messages.length,
              ),
            ),
          ),
          Expanded(
            flex: MediaQuery.of(context).viewInsets.bottom == 0 ? 3 : 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                )
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 100,
                      child: TextField(
                        onChanged: (String message){
                          newMessage = message;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 43,
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        child: ElevatedButton(
                          child: Text("Отправить"),
                          onPressed: () async {
                            if (hubConnection.state == HubConnectionState.Connected){
                              int userID = await SecureStorage.getUserID();
                              await hubConnection.invoke("SendNewMessage", args: <Object>[newMessage, userID, _roomID]);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _getListMessages(int index){
    return GestureDetector(
      child: Container(
        alignment: usernames[index] == _currentUsername ? Alignment.centerRight : Alignment.centerLeft,
        margin: EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white54,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                child: Text(usernames[index], style: TextStyle(fontSize: 13),),
              ),
              Container(
                child: Text(messages[index], style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initSignalR() {
    hubConnection = HubConnectionBuilder()
        .withUrl("${baseURL}messagehub",
        options: HttpConnectionOptions(
            accessTokenFactory: () async => await SecureStorage.getAccessToken()
        ))
        .build();
    hubConnection.onclose((error) => {print("Connection close by ${error}")});
    hubConnection.on("ReceiveNewMessage", _handleNewMessage);
    hubConnection.start().then((value) {
      if (hubConnection.state == HubConnectionState.Connected) {
        SecureStorage.getUserID().then((userID) =>
            hubConnection.invoke("Enter", args: <Object>[userID, _roomID]));
      }
    });
  }

  _handleNewMessage(List<Object> args) {
    setState(() {
      messages.add(args[0].toString());
      usernames.add(args[1].toString());
    });
  }
  /*Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        centerTitle: true,
      ),
      backgroundColor: Color(BGcolor),
      body: Stack(
        children: [
          Container(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return _getListMessages(index);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black,),
              itemCount: messages.length,
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
                    onPressed: () async{
                        /*hubConnection.state == HubConnectionState.Connected ? await hubConnection.stop() : await hubConnection.start();
                        setState(() {
                        });*/
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
                        int userID = await SecureStorage.getUserID();
                        await hubConnection.invoke("SendNewMessage", args: <Object>[newMessage, userID, _roomID]);
                      }
                      setState(() {
                        //messages.add(newMessage);
                      });
                    },
                ),
                )
              ],
            ),
          )
        ],
      )
    );*/

}

