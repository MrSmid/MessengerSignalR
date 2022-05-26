import 'package:flutter/material.dart';
import 'package:messenger_signal_r/pages/autorization_page.dart';
import 'package:messenger_signal_r/constants.dart';

import 'pages/chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white
      ),
      home: const AutorizationPage(),
    );
  }
}

