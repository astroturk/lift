import 'package:flutter/material.dart';

class PostsTab extends StatefulWidget {
  const PostsTab({Key key}) : super(key: key);

  @override
  _PostsTabState createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(child: Text('Posts Tab')),
      ),
    );
  }
}
