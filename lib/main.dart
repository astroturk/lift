import 'package:flutter/material.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/home_screen/home_screen.dart';
import 'package:lift/screens/registration_screen/registration_utils.dart';
import 'package:lift/services/authentication.dart';
import 'package:lift/services/firebase_operations.dart';
import 'package:lift/services/workouts.dart';
import 'package:lift/screens/home_screen/tab_helpers/add_step_helper.dart';
import 'package:lift/screens/home_screen/tabs/add_step_tab.dart';
import 'package:lift/screens/home_screen/tab_helpers/create_workout_utils.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen/login_screen.dart';
import 'screens/authentication_screen/authentication_screen.dart';
import 'screens/registration_screen/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MultiProvider used to provide various services to the App Sections
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          backgroundColor: Colors.black,
          primaryColorDark: SpecialPurple,
          primaryColor: SpecialPurple,
        ),
        initialRoute: AuthenticationScreen.id,
        routes: {
          AuthenticationScreen.id: (context) => AuthenticationScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          AddStepTab.id: (context) => AddStepTab(),
        },
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => AddStepHelper()),
        ChangeNotifierProvider(create: (_) => CreateWorkoutUtils()),
        ChangeNotifierProvider(create: (_) => HomeScreenHelpers()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => RegisterUtils()),
        ChangeNotifierProvider(create: (_) => Workouts()),
      ],
    );
  }
}
