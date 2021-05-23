import 'package:flutter/material.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({Key key}) : super(key: key);

  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Text('Chats Tab'),
      ),
    );
  }
}
