import 'package:flutter/material.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/constants/constants.dart';

class EndScreen extends StatefulWidget {
  static String id = 'end_screen';
  const EndScreen({Key key}) : super(key: key);

  @override
  _EndScreenState createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'LIFT',
                  style: TextTitleWhite.copyWith(fontSize: 150),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Congratulations',
                  style: TextLargeWhite,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'You completed the Workout',
                  style: TextMediumWhite,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: NavigationButton(
                    text: 'Return',
                    onPressed: (){
                      Navigator.pop(context);
                    }
                  ),
                )
              ]
          ),
        )
      ),
    );
  }
}
