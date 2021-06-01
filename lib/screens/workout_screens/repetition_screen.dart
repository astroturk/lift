import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/workout_screens/workout_helpers.dart';
import 'package:provider/provider.dart';

class RepetitionScreen extends StatefulWidget {
  static String id = 'repetition_screen';
  const RepetitionScreen({Key key}) : super(key: key);

  @override
  _RepetitionScreenState createState() => _RepetitionScreenState();
}

class _RepetitionScreenState extends State<RepetitionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpecialDarkGrey,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CachedNetworkImage(imageUrl: Provider.of<WorkoutHelpers>(context, listen: false).currentImage),
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
                          onPressed: () => Provider.of<WorkoutHelpers>(context, listen: false).nextStep(context),
                          backgroundColor: SpecialPurple,
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 30,
                          ),
                          heroTag: null,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10, right: 20,),
                    alignment: Alignment.bottomRight,
                    child: Card(
                      color: SpecialPurple,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top:10, right: 10, left: 10),
                            child: Text('REPS : ', style: TextMediumWhite,)
                          ),
                          Padding(
                              padding:  EdgeInsets.only(bottom:10, right: 10, left: 10),
                              child: Text('80', style: TextLargeWhite.copyWith(fontSize: 70),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: SpecialGrey,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.2,
              ),
              child: Text(
                Provider.of<WorkoutHelpers>(context, listen: false).currentMessage,
                style:TextSmallWhite.copyWith(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
