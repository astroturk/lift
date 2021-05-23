import 'package:flutter/material.dart';

class CreateWorkoutTab extends StatefulWidget {
  const CreateWorkoutTab({Key key}) : super(key: key);

  @override
  _CreateWorkoutTabState createState() => _CreateWorkoutTabState();
}

class _CreateWorkoutTabState extends State<CreateWorkoutTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Text('Create Workout Tab'),
      ),
    );
  }
}
