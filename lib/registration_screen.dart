import 'package:flutter/material.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/components/form_input.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'LIFT',
          style: TextStyle(
            fontSize: 50.0,
            fontFamily: 'BigShoulder',
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Your Account!',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5EF1CE),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            FormInput(
              onChange: (value) {},
              labelText: 'Email',
            ),
            SizedBox(
              height: 15.0,
            ),
            FormInput(
              onChange: (value) {},
              labelText: 'Password',
            ),
            SizedBox(
              height: 20.0,
            ),
            NavigationButton(
              onPressed: (){},
              text: 'Register',
              textColor: Color(0xFF5EF1CE),
            ),
          ],
        ),
      ),
    );
  }
}
