import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger_signal_r/Auth/APIService.dart';
import 'package:messenger_signal_r/Auth/authentication_service.dart';
import 'package:messenger_signal_r/Model/rooms_response.dart';
import 'package:messenger_signal_r/pages/chat_page.dart';
import 'package:messenger_signal_r/constants.dart';
import 'package:messenger_signal_r/pages/rooms_page.dart';
import 'package:messenger_signal_r/storage/secure_storage.dart';

class AutorizationPage extends StatefulWidget {
  const AutorizationPage({Key? key}) : super(key: key);

  @override
  State<AutorizationPage> createState() {
    return _AutorizationPageState();
  }
}

class _AutorizationPageState extends State<AutorizationPage>{
  late String _username;
  late String _password;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(25),
            alignment: Alignment.center,
            child: Text("Вход",
              style: TextStyle(
                fontSize: 35,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(25),
            child: TextField(
              onChanged: (String username) {_username = username;},
              style: TextStyle(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.login_rounded, color: Colors.black),
                hintText: "Логин:",
                hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.3,
                    )
                ),
              ),
              cursorColor: Colors.black,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(25),
              child: TextField(
                onChanged: (String password) {_password = password;},
                style: TextStyle(color: Colors.black, fontSize: 16),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password_rounded, color: Colors.black,),
                  hintText: "Пароль:",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.3,
                      )
                  ),
                  fillColor: Colors.black,
                ),
                cursorColor: Colors.black,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              )
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(25),
            child: ElevatedButton(
              onPressed: () async {
                await AuthenticationService.authentication(_username, _password)
                    .then((authStatus) {
                      if (authStatus == true) {
                        ApiService api = ApiService();
                        SecureStorage.getUserID().then((userID) async {
                          Response response = await api.requestPOST("GetRooms?userID=${userID}");

                          List<Rooms> rooms = RoomsResponse.fromJson(response.data).rooms ?? <Rooms>[];
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RoomsPage(rooms, _username)));
                        });
                        /*Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ChatPage()));*/
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: "Неверный логин или пароль",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Color(0x33000000),
                            textColor: Colors.black,
                            fontSize: 16.0
                        );
                      }
                });
              },
              child: Text("Войти", style: TextStyle(fontSize: 15, color: Colors.black),),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 40),
                elevation: 0,
                primary: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: Colors.black,
                    width: 2.3,
                  ),
                ),
              ),
            ),
          )
        ],
        ),
      ),
    );
  }
}