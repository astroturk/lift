import 'package:flutter/material.dart';
import 'package:lift/screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/authentication_screen.dart';
import 'screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        backgroundColor: Colors.black,
      ),
      initialRoute: AuthenticationScreen.id,
      routes: {
        AuthenticationScreen.id: (context) => AuthenticationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
