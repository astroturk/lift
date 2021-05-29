import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/login_screen/login_screen.dart';
import 'package:lift/screens/registration_screen/registration_screen.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/services/authentication.dart';
import 'package:provider/provider.dart';

class AuthenticationScreen extends StatefulWidget {
  static String id = 'authentication_screen';
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> with SingleTickerProviderStateMixin{
  // Animation Controller for background animations on Authentication Screen
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    controller = AnimationController(
      duration: Duration(seconds: 2),
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
      backgroundColor: SpecialPurple,
      body: Stack(
        children: [
          // Top background Animation
          FadeTransition(
            opacity: animation,
            child: Container(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'images/topBg.png',
              ),
            ),
          ),

          // Bottom background Animation
          FadeTransition(
            opacity: animation,
            child: Container(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'images/bottomLeftBg.png',
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 180,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.black.withOpacity(0.8),
                  child: Row(
                    children: [
                      Text(
                        'LIFT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 150.0,
                          fontFamily: 'BigShoulder',
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            // Login Button
                            NavigationButton(
                              text: 'Login',
                              onPressed: (){
                                Navigator.pushNamed(context, LoginScreen.id);
                              },
                            ),

                            // Register Button
                            NavigationButton(
                              text: 'Register',
                              onPressed: (){
                                Navigator.pushNamed(context, RegistrationScreen.id);
                              },
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
