import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lift/login_screen.dart';
import 'package:lift/registration_screen.dart';
import 'package:lift/components/navigation_button.dart';

class AuthenticationScreen extends StatefulWidget {
  static String id = 'authentication_screen';
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween(
      begin: 0.0,
      end: 0.8,
    ).animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Color(0xFF6531ff),
              child: Container(
                padding: EdgeInsets.only(top: 40.0),
                child: Stack(
                  children: [
                    FadeTransition(
                      opacity: animation,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Image.asset(
                          'images/boxer.png',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30.0, top: 60.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'LIFT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 120.0,
                          fontFamily: 'BigShoulder',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
          SizedBox(
            height: 190,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Start your Journey!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  NavigationButton(
                    onPressed: (){
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    text: 'Login',
                    textColor: Colors.white,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  NavigationButton(
                    onPressed: (){
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                    text: 'Register',
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

