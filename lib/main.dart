import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'authentication_screen.dart';
import 'registration_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: AuthenticationScreen.id,
      routes: {
        AuthenticationScreen.id: (context) => AuthenticationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
      },
    );
  }
}
