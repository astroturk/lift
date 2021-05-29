import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';
import 'package:lift/services/authentication.dart';
import 'package:lift/screens/home_screen/tab_helpers/create_workout_utils.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'firebase_operations.dart';


class Workout{
  String userUid;
  String userName;
  String thumbnailUrl;
  String title;
  String description;
  String completionTime;
  List <WorkoutStep> steps = [];

  dynamic data(BuildContext context) {
    List stepsData = [];
    for (WorkoutStep step in steps){
      stepsData.add(step.data());
    }

    thumbnailUrl = Provider.of<CreateWorkoutUtils>(context, listen: false).getThumbnailUrl;
    title = Provider.of<CreateWorkoutUtils>(context, listen: false).getTitle;
    description = Provider.of<CreateWorkoutUtils>(context, listen: false).getDescription;
    completionTime = Provider.of<CreateWorkoutUtils>(context, listen: false).getDuration;

    if (title == '') title = 'Title';
    if (description == '') description = 'Description';
    if (thumbnailUrl == null || thumbnailUrl == '') thumbnailUrl = 'https://firebasestorage.googleapis.com/v0/b/lift-604d3.appspot.com/o/assets%2Fdefault_thumbnail.png?alt=media&token=d49a2328-0f10-4931-8cd1-3b4ff570ba15';
    var workoutData = {
      'workout_id': Provider.of<CreateWorkoutUtils>(context, listen: false).getWorkoutId,
      'user_uid' : Provider.of<Authentication>(context, listen: false).getUserUid,
      'user_name' : Provider.of<HomeScreenHelpers>(context, listen: false).getUserName,
      'thumbnail_url' : thumbnailUrl,
      'steps_data': stepsData,
      'title': title,
      'description': description,
      'completion_time': completionTime,
      'time': Timestamp.now(),
      'likes': {},
    };
    return workoutData;
  }
}

class WorkoutStep{
  String type;
  int duration;
  String imageUrl;
  int reps;
  String message;
  WorkoutStep({this.type, this.duration, this.imageUrl, this.reps, this.message});

  dynamic data(){
    var stepData = {
      'type': type,
      'duration': duration.toString(),
      'image_url': imageUrl,
      'reps': reps.toString(),
      'message': message,
    };
    return stepData;
  }
}

class Workouts extends ChangeNotifier{
  Workout currentWorkout;
  Workout get getCurrentWorkout => currentWorkout;

  final picker  = ImagePicker();
  bool stepImageSelected = false;
  File stepImage;
  File get getStepImage => stepImage;
  String stepImageUrl;
  String get getStepImageUrl => stepImageUrl;


  void createNewWorkout(BuildContext context){
    currentWorkout = Workout();
    Provider.of<CreateWorkoutUtils>(context, listen: false).clearWorkoutData();
    notifyListeners();
  }

  void addWorkoutStep(BuildContext context, WorkoutStep step){
    if (step.imageUrl == null) {
      if (step.type == 'Rest') step.imageUrl = 'https://firebasestorage.googleapis.com/v0/b/lift-604d3.appspot.com/o/assets%2Frest.png?alt=media&token=c0fd506c-1848-43d1-a434-70c1550c30d8';
      else step.imageUrl = 'https://firebasestorage.googleapis.com/v0/b/lift-604d3.appspot.com/o/assets%2Fstart.png?alt=media&token=d51d4699-b6d0-472c-991b-dfde5eec0076';
    }
    currentWorkout.steps.add(step);
    print(currentWorkout.steps.length);
    stepImageSelected = false;
    stepImage = null;
    stepImageUrl = null;
    Navigator.pop(context);
    notifyListeners();
  }

  void deleteWorkoutStep(BuildContext context, int index){
    currentWorkout.steps.removeAt(index);
    notifyListeners();
  }

  void changeImageSelected(bool currentState) {
    stepImageSelected = currentState;
    notifyListeners();
  }

  Future pickStepImage(BuildContext context, ImageSource source) async{
    final pickerStepImage = await picker.getImage(source: source);
    pickerStepImage == null ? print('Select Image') : stepImage = File(pickerStepImage.path);
    print("Image Step Path Chosen By User : " + stepImage.path);
    stepImage != null ? Provider.of<FirebaseOperations>(context, listen: false).uploadStepImage(context) : print('Image Upload Error');
    notifyListeners();
  }

  void setStepImageUrl(String url){
    stepImageUrl = url;
  }

  void saveCurrentWorkout(BuildContext context) {
    if (currentWorkout.steps.length == 0) throw 'Please add atleast one step';
    Provider.of<CreateWorkoutUtils>(context, listen: false).assignUuid();
    print(currentWorkout.data(context));
    try {
      FirebaseFirestore.instance.collection('workouts')
          .doc(Provider
          .of<Authentication>(context, listen: false)
          .getUserUid)
          .collection('userWorkouts')
          .doc(Provider
          .of<CreateWorkoutUtils>(context, listen: false)
          .getWorkoutId)
          .set(currentWorkout.data(context));
      print('Workout Information Stored');
      Provider.of<Workouts>(context, listen: false).createNewWorkout(context);
    } catch (error) {
      print(error);
      throw 'Could Not Create Workout';
    }
  }
}