import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lift/model/step_workout.dart';
import 'package:lift/model/workout_info.dart';
import 'package:lift/screens/workout_screens/end_screen.dart';
import 'package:lift/screens/workout_screens/repetition_screen.dart';
import 'package:lift/screens/workout_screens/rest_screen.dart';
import 'package:lift/screens/workout_screens/timed_screen.dart';

class WorkoutHelpers with ChangeNotifier {
  WorkoutInfo info;
  int currentIndex = -1;
  bool imagesLoaded = true;
  String thumbnailUrl;
  Image thumbnailImage;
  int numSteps;
  List<Image> images = [];
  List<StepWorkout> steps = [];

  get currentImage => steps[currentIndex].imageUrl;
  get currentMessage => steps[currentIndex].message;
  get currentDuration => steps[currentIndex].duration;
  get currentReps => steps[currentIndex].reps;



  nextStep(BuildContext context){
    currentIndex++;
    if (currentIndex == numSteps){
      Navigator.pushReplacementNamed(context, EndScreen.id);
    } else if (steps[currentIndex].type == 'Timed'){
      Navigator.pushReplacementNamed(context, TimedScreen.id);
    } else if (steps[currentIndex].type == 'Rest'){
      Navigator.pushReplacementNamed(context, RestScreen.id);
    } else if (steps[currentIndex].type == 'Repetition'){
      Navigator.pushReplacementNamed(context, RepetitionScreen.id);
    }
  }

  closeWorkout(BuildContext context){
    Navigator.pop(context);
  }

  loadNewWorkout(WorkoutInfo newInfo) async {
    this.info = newInfo;
    imagesLoaded = false;
    notifyListeners();

    images.clear();
    steps.clear();
    thumbnailUrl = info.thumbnailUrl;
    numSteps = info.steps.length;
    currentIndex = -1;
    for (int i = 0; i < numSteps; i++)
      steps.add(StepWorkout.fromDocument(info.steps[i]));

    await DefaultCacheManager().downloadFile(info.thumbnailUrl).then((_){});
    await Future.wait(steps
        .map((step) => DefaultCacheManager().downloadFile(step.imageUrl).then((_){}))
        .toList());

    imagesLoaded = true;
    notifyListeners();
  }
}