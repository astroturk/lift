import 'package:flutter/material.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/components/form_input.dart';
import 'package:lift/components/custom_alert_dialog_box.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/home_screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:lift/services/authentication.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool isEnabled = true;

  // Handle pressing navigation button
  void handleSubmit(BuildContext context) async {
    setState(() {isEnabled = false;});
    try {
      await Provider.of<Authentication>(context, listen: false)
          .logIntoAccount(email, password);
      Navigator.pushNamed(context, HomeScreen.id);
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (context) => CustomAlertDialogBox(
            context: context,
            title: 'Error',
            message: 'Could Not Log In User',
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK', style: TextMediumGreen, ),
              ),
            ],
          )
      );
    }
    setState(() {isEnabled = true;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: SpecialPurple,
        title: Text(
          'LIFT',
          style: TextStyle(
            fontSize: 50.0,
            fontFamily: 'BigShoulder',
            color: Colors.white,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextLargePurple,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                  // Email input Box
                  FormInput(
                    onChange: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    labelText: 'Email',
                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  // Password input box
                  FormInput(
                    onChange: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: true,
                    labelText: 'Password',
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  NavigationButton(
                    // Handle Submission and accordingly Enable/Disable the button
                    onPressed: isEnabled ? (){ handleSubmit(context); } : () {},
                    text: 'Login',
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
