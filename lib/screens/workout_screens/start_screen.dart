import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/workout_screens/workout_helpers.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  CountDownController _controller = CountDownController();
  bool _isPaused = false;
  
  
  handlePause(){
    if (_isPaused){
      _controller.resume();
      setState(() {
        _isPaused = false;
      });
    }
    else {
      _controller.pause();
      setState(() {
        _isPaused = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpecialDarkGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CachedNetworkImage(imageUrl: Provider.of<WorkoutHelpers>(context, listen: false).thumbnailUrl),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        FloatingActionButton(
                          onPressed: () => Provider.of<WorkoutHelpers>(context, listen: false).closeWorkout(context),
                          backgroundColor: SpecialPurple,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          heroTag: null,
                        ),
                        SizedBox(width: 10,),
                        FloatingActionButton(
                          onPressed: () => Provider.of<WorkoutHelpers>(context, listen: false).nextStep(context),
                          backgroundColor: SpecialPurple,
                          child: Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 30,
                          ),
                          heroTag: null,
                        ),
                        SizedBox(width: 10,),
                        FloatingActionButton(
                          onPressed: () => handlePause(),
                          backgroundColor: SpecialPurple,
                          child: Icon(
                            _isPaused ? Icons.play_arrow : Icons.pause,
                            color: Colors.white,
                            size: 30,
                          ),
                          heroTag: null,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20, right: 20),
                    alignment: Alignment.bottomRight,
                    child: CircularCountDownTimer(
                      width: 150,
                      height: 150,
                      duration: 10,
                      fillColor: Colors.black,
                      ringColor: SpecialPurple,
                      controller: _controller,
                      strokeWidth: 15.0,
                      strokeCap:  StrokeCap.square,
                      isTimerTextShown: true,
                      isReverse: true,
                      onComplete: () {
                        Provider.of<WorkoutHelpers>(context, listen: false).nextStep(context);
                      },
                      textStyle: TextStyle(fontSize: 35, color: Colors.white,),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              color: SpecialGrey,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'Prepare for the Workout',
                style: TextMediumWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
