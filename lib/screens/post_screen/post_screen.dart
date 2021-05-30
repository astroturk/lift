import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/model/post.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String workoutId;

  PostScreen({ this.userId, this.workoutId });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Post',
          style: TextTabTitle,
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('workouts')
            .doc(userId)
            .collection('userWorkouts')
            .doc(workoutId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return Container(
              child: Center(
                child: SpinKitDoubleBounce(
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
            );
          }

          Post post = Post.fromDocument(snapshot.data.data());
          return ListView(
            children: [
              Container(
                child: post,
              ),
            ],
          );
          //return Container();
        },
      ),
    );
  }
}
