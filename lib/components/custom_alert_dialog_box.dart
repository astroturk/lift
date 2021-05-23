import 'package:flutter/material.dart';

class CustomAlertDialogBox extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;
  final BuildContext context;

  CustomAlertDialogBox({@required this.context, this.actions, this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 25.0,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          color: Color(0xFF5EF1CE),
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w100,
          color: Colors.white,
        ),
      ),
      actions: actions,
    );
  }
}
