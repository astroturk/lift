import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift/services/firebase_operations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateWorkoutUtils extends ChangeNotifier{
  final picker  = ImagePicker();
  bool thumbnailSelected = false;
  bool imageUploading = false;
  File thumbnail;
  File get getThumbnail => thumbnail;
  String thumbnailUrl;

  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  String title = '';
  String description = '';
  String workoutId = '';

  String _title = '';
  String _description = '';
  String _duration = '';
  String _thumbnailUrl = '';
  String _workoutId = '';

  String get getTitle => _title;
  String get getDescription => _description;
  String get getDuration => _duration;
  String get getThumbnailUrl => _thumbnailUrl;
  String get getWorkoutId => _workoutId;
  bool get getImageUploadState => imageUploading;

  void changeUploadState(bool current) {
    imageUploading = current;
    notifyListeners();
  }

  void changeThumbnailSelected(bool currentState) {
    thumbnailSelected = currentState;
    notifyListeners();
  }

  void updateWorkoutInfo(BuildContext context){
    if (workoutId == null) workoutId = Uuid().v4();
    _workoutId = workoutId;
    if (seconds != 0 || minutes != 0 || hours != 0) _duration = Duration(seconds: seconds, minutes: minutes, hours: hours).inSeconds.toString();
    if (title != '') _title = title;
    if (description != '') _description = description;
    if (thumbnailUrl != null) _thumbnailUrl = thumbnailUrl;

    print(_workoutId);
    print(_title);
    print(_duration);
    print(_description);
    print(_thumbnailUrl);

    title = '';
    description = '';
    notifyListeners();
  }

  void clearWorkoutData() {
    thumbnailSelected = false;
    thumbnail = null;
    thumbnailUrl = '';
    _thumbnailUrl = '';

    title = '';
    _title = '';

    description = '';
    _description = '';

    workoutId = Uuid().v4();
    _workoutId = workoutId;

    _duration = '';
    seconds = 0;
    minutes = 0;
    hours = 0;
    notifyListeners();
  }


  void assignUuid(){
    if (_workoutId == null){
      workoutId = Uuid().v4();
      _workoutId = workoutId;
    }
  }

  Future pickThumbnail(BuildContext context, ImageSource source) async{
    final pickerThumbnail = await picker.getImage(source: source);
    pickerThumbnail == null ? print('Select Image') : thumbnail = File(pickerThumbnail.path);

    print("Thumbnail Path Chosen By User : " + pickerThumbnail.path);
    thumbnail != null ? Provider.of<FirebaseOperations>(context, listen: false).uploadThumbnail(context) : print('Image Upload Error');
    notifyListeners();
  }
}
