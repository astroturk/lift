import 'package:flutter/material.dart';
import 'package:lift/constants/constants.dart';

class NavigationButton extends StatelessWidget {
  final onPressed;
  final Color textColor;
  final String text;

  NavigationButton({@required this.onPressed, this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(SpecialPurple.withOpacity(0.7)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )
        ),
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
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}