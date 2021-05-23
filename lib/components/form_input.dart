import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String labelText;
  final onChange;
  final obscureText;
  FormInput({@required this.onChange, this.labelText, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      textAlign: TextAlign.left,
      onChanged: onChange,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}