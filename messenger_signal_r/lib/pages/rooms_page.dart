import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_signal_r/Auth/APIService.dart';
import 'package:messenger_signal_r/Model/messages_response.dart';
import 'package:messenger_signal_r/Model/rooms_response.dart';
import 'package:messenger_signal_r/pages/chat_page.dart';
import 'package:messenger_signal_r/storage/secure_storage.dart';

import '../constants.dart';

class RoomsPage extends StatefulWidget {
  List<Rooms> rooms;
  String username;
  RoomsPage(this.rooms, this.username, {Key? key}) : super(key: key);

  @override
  State<RoomsPage> createState() {
    return _RoomsPageState(rooms, username);
  }
}

class _RoomsPageState extends State<RoomsPage> {
  List<Rooms> rooms;
  String username;

  _RoomsPageState(this.rooms, this.username) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Color(BGcolor),
        body: Container(
          child: Column(
            children: [
              Expanded(
                flex: 1,
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
                    "Имя пользователя: $username",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 11,
                child: Container(
                  child: ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (BuildContext context, int index){
                      return roomItem(index);
                    },
                  ),
                )
              )
            ],
          ),
        ),
    );
  }

  Widget roomItem(int index)
  {
    return GestureDetector(
      onTap: (){
        ApiService api = ApiService();
        SecureStorage.getUserID().then((userID) async {
          Response response = await api.requestPOST("GetMessages?roomID=${rooms[index].id}");
          List<Messages> messages = MessagesResponse.fromJson(response.data).messages ?? <Messages>[];
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(messages, username, rooms[index].name ?? "", rooms[index].id ?? 0)));
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black38)
        ),
        child: Container(
          padding: EdgeInsets.all(25),
          alignment: Alignment.centerLeft,
          child: Text(
            rooms[index].name ?? "room name",
            style: TextStyle(
                fontSize: 18
            ),
          ),
        ),
      ),
    );
  }
}