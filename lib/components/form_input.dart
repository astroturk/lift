import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String labelText;
  final onChange;
  FormInput({@required this.onChange, this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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