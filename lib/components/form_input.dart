import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lift/constants/constants.dart';

const formInputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  labelStyle: TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: Colors.white,
  ),
  border: OutlineInputBorder(),
);

class FormInput extends StatelessWidget {
  final String labelText;
  final onChange;
  final obscureText;
  final initialValue;
  FormInput({@required this.onChange, this.labelText, this.obscureText = false, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: obscureText,
      textAlign: TextAlign.left,
      onChanged: onChange,
      decoration: formInputDecoration.copyWith(labelText: labelText),
    );
  }
}

class FormNumberInput extends StatelessWidget {
  final String labelText;
  final onChange;
  final obscureText;
  FormNumberInput({@required this.onChange, this.labelText, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      obscureText: obscureText,
      textAlign: TextAlign.left,
      onChanged: onChange,
      decoration: formInputDecoration.copyWith(labelText: labelText),
    );
  }
}

