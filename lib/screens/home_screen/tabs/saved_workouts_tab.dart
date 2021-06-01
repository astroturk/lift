import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/profile_screen/profile_screen.dart';
import 'package:lift/screens/start_workout_screen/start_workout_screen.dart';
import 'package:lift/services/authentication.dart';
import 'package:provider/provider.dart';

class SavedWorkoutsTab extends StatefulWidget {
  const SavedWorkoutsTab({Key key}) : super(key: key);

  @override
  _SavedWorkoutsTabState createState() => _SavedWorkoutsTabState();
}

class _SavedWorkoutsTabState extends State<SavedWorkoutsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 15,
        title: Text(
          'Saved Workouts',
          style: TextTabTitle,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('saved')
            .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
            .collection('savedWorkouts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SpinKitDoubleBounce(
              color: Colors.white,
              size: 40.0,
            );
          }
          List<Widget> workoutList = [];
          snapshot.data.docs.forEach((doc){
            workoutList.add(WorkoutCard.formDocument(doc.data()));
          });

          return GridView.count(
            padding: EdgeInsets.all(10),
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: workoutList,
          );
        },
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final onPressed;
  final icon;

  CustomIconButton({this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.white, // button color
        child: InkWell(
          splashColor: SpecialPurple, // inkwell color
          child: SizedBox(width: 30, height: 30, child: Icon(icon, size: 22, color: Colors.black,)),
          onTap: onPressed,
        ),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String description;
  final String ownerId;
  final String workoutId;
  final steps;

  WorkoutCard({this.thumbnailUrl, this.title, this.description, this.ownerId, this.workoutId, this.steps});

  factory WorkoutCard.formDocument(dynamic doc){
    return WorkoutCard(
      thumbnailUrl: doc['thumbnailUrl'],
      title: doc['title'],
      description: doc['description'],
      workoutId: doc['workoutId'],
      ownerId: doc['ownerId'],
      steps: doc['steps'],
    );
  }
  
  removeSavedWorkout(BuildContext context) {
    String currentUser = Provider.of<Authentication>(context, listen: false).getUserUid;
    FirebaseFirestore.instance.collection('workouts')
        .doc(ownerId)
        .collection('userWorkouts')
        .doc(workoutId)
        .update({'saves.$currentUser': false,});
    FirebaseFirestore.instance.collection('saved')
        .doc(currentUser)
        .collection('savedWorkouts')
        .doc(workoutId)
        .get()
        .then((doc){
      if (doc.exists) {doc.reference.delete();}
    });
  }

  showProfile(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(userId: ownerId,)),
    );
  }

  showStartWorkout(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartWorkoutScreen(ownerId: ownerId, workoutId: workoutId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(thumbnailUrl),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                CustomIconButton(onPressed: () => removeSavedWorkout(context), icon: Icons.remove),
                SizedBox(width: 10,),
                CustomIconButton(onPressed: () => showProfile(context), icon: Icons.person),
                SizedBox(width: 10,),
                CustomIconButton(onPressed: () => showStartWorkout(context), icon: Icons.directions_run),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

