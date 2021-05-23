import 'package:flutter/material.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/components/form_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lift/components/custom_alert_dialog_box.dart';
import 'package:lift/components/constants.dart';
import 'package:lift/screens/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Color(0xFF6531ff),
          title: Text(
            'LIFT',
            style: TextTitleWhite,
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
                style: TextLargeGreen,
              ),
              SizedBox(
                height: 20.0,
              ),
              FormInput(
                onChange: (value) {
                  email = value;
                },
                labelText: 'Email',
              ),
              SizedBox(
                height: 15.0,
              ),
              FormInput(
                onChange: (value) {
                  password = value;
                },
                obscureText: true,
                labelText: 'Password',
              ),
              SizedBox(
                height: 20.0,
              ),
              NavigationButton(
                onPressed: () async {
                  setState(() {_showSpinner = true;});
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password
                    );
                    if (newUser != null){
                      print('New User Created');
                      Navigator.pushNamed(context, HomeScreen.id);
                    }
                  } catch (error){
                    print(error);
                    showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialogBox(
                          context: context,
                          title: 'Error',
                          message: 'Could Not Create User',
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text(
                                'OK',
                                style: TextMediumGreen,
                              ),
                            ),
                          ],
                        ),
                    );
                  }
                  setState(() {_showSpinner = false;});
                },
                text: 'Register',
                textColor: Color(0xFF5EF1CE),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
