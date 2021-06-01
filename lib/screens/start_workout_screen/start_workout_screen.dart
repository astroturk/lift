import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/model/user.dart';
import 'package:lift/model/workout_info.dart';
import 'package:lift/screens/workout_screens/start_screen.dart';
import 'package:lift/screens/workout_screens/workout_helpers.dart';
import 'package:provider/provider.dart';

class StartWorkoutScreen extends StatelessWidget {
  final String ownerId;
  final String workoutId;
  StartWorkoutScreen({this.ownerId, this.workoutId});

  buildWorkoutHeader() {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(ownerId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: SpinKitDoubleBounce(
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
            );
          }

          User user = User.fromDocument(snapshot.data.data());
          return ListTile(
            tileColor: SpecialGrey,
            contentPadding: EdgeInsets.only(left: 10),
            minLeadingWidth: 5,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              backgroundColor: Colors.grey,
              radius: 18,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => print('Show Profile'),
                  child: Text(
                    user.fullName,
                    style: TextSmallWhite,
                  ),
                ),
                Text(
                  user.username,
                  style: TextSmallWhite.copyWith(color: Colors.white70),
                ),
              ],
            ),
          );
        }
    );
  }

  buildWorkoutBody() {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('workouts').doc(ownerId).collection('userWorkouts').doc(workoutId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return SpinKitDoubleBounce(
              color: Colors.white,
              size: 40.0,
            );
          }
          //print(snapshot.data.data());
          WorkoutInfo data = WorkoutInfo.fromDocument(snapshot.data.data());
          print(data.totalTime);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      image: NetworkImage(data.thumbnailUrl),
                      fit: BoxFit.contain
                  ),
                ),
              ),
              Container(
                color: SpecialGrey,
                constraints: BoxConstraints(
                    minHeight: (MediaQuery.of(context).size.height - MediaQuery.of(context).size.width)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Completion Time :', style: TextSmallWhite,),
                              Text(
                                (data.totalTime == null || data.totalTime == '') ? 'Not Specified' : Duration(seconds: int.parse(data.totalTime)).toString().split('.')[0],
                                style: TextLargeGreen,
                              ),
                            ],
                          ),
                          FloatingActionButton(
                            backgroundColor: SpecialPurple,
                            onPressed: () async {
                              print('play button pressed');
                              await Provider.of<WorkoutHelpers>(context, listen: false).loadNewWorkout(data);
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return StartScreen();
                              }));
                            },
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 10,
                      thickness: 10,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(data.title, style: TextMediumWhite.copyWith(fontSize: 20),),
                    ),
                    Divider(
                      height: 4,
                      thickness: 2,
                      endIndent: 10,
                      indent: 10,
                      color: Colors.white12,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(data.description, style: TextSmallWhite.copyWith(color: Colors.white70),),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: 15,
        title: Text(
          'Start Workout',
          style: TextTabTitle,
        ),
      ),
      body: ListView(
        children: [
          buildWorkoutHeader(),
          buildWorkoutBody(),
        ],
      ),
    );
  }
}

