import 'package:flutter/material.dart';

class StartWorkoutTab extends StatefulWidget {
  const StartWorkoutTab({Key key}) : super(key: key);

  @override
  _StartWorkoutTabState createState() => _StartWorkoutTabState();
}

class _StartWorkoutTabState extends State<StartWorkoutTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Text('Start Workout Tab'),
      ),
    );
  }
}
