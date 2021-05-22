import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final onPressed;
  final Color textColor;
  final String text;

  NavigationButton({@required this.onPressed, this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF303030)),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            color: textColor,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}