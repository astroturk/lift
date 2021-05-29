import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';
import 'package:lift/screens/registration_screen/registration_utils.dart';
import 'package:lift/services/workouts.dart';
import 'package:lift/screens/home_screen/tab_helpers/add_step_helper.dart';
import 'package:provider/provider.dart';
import 'package:lift/services/authentication.dart';
import 'package:lift/screens/home_screen/tab_helpers/create_workout_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class FirebaseOperations with ChangeNotifier{
  UploadTask imageUploadTask;
  final Reference storageRef = FirebaseStorage.instance.ref();

  Future uploadUserAvatar(BuildContext context) async{
    print('Compressing image');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(Provider.of<RegisterUtils>(context, listen:false).getUserAvatar.readAsBytesSync());
    String profileImageId = Uuid().v4();
    final compressedImageFile = File('$path/img_$profileImageId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    print('Image Compressed');

    print('Upload Task Started');
    Reference imageReference = FirebaseStorage.instance.ref().child('profile_image/image_${profileImageId}_${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(compressedImageFile);

    await imageUploadTask.whenComplete((){print('Image Uploaded');});

    imageReference.getDownloadURL().then((value){
      Provider.of<RegisterUtils>(context, listen: false).userAvatarUrl = value.toString();
      print('the user profile avatar url => ${Provider.of<RegisterUtils>(context, listen: false).userAvatarUrl}');
      Provider.of<RegisterUtils>(context, listen: false).changeAvatarSelected(true);
      notifyListeners();
    });
    Provider.of<RegisterUtils>(context, listen: false).changeUploadState(false);
  }

  Future uploadStepImage(BuildContext context) async{
    print('Upload Task Started');
    Reference imageReference = FirebaseStorage.instance.ref().child('userWorkoutStep/${Provider.of<Workouts>(context, listen:false).getStepImage.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(Provider.of<Workouts>(context, listen:false).getStepImage);

    await imageUploadTask.whenComplete((){print('Image Uploaded');});

    imageReference.getDownloadURL().then((value){
      Provider.of<Workouts>(context, listen: false).setStepImageUrl(value.toString());
      print('the Step Image url => ${Provider.of<Workouts>(context, listen: false).getStepImageUrl}');
      Provider.of<Workouts>(context, listen: false).changeImageSelected(true);
      notifyListeners();
    });

    Provider.of<AddStepHelper>(context, listen: false).changeUploadState(false);
  }

  Future uploadThumbnail(BuildContext context) async{
    print('Compressing image');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(Provider.of<CreateWorkoutUtils>(context, listen:false).getThumbnail.readAsBytesSync());
    String workoutId = Uuid().v4();
    Provider.of<CreateWorkoutUtils>(context, listen: false).workoutId = workoutId;
    final compressedImageFile = File('$path/img_$workoutId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    print('Image Compressed');

    print('Upload Task Started');
    Reference imageReference = storageRef.child('workout_thumbnail/workout_$workoutId.jpg');
    imageUploadTask = imageReference.putFile(compressedImageFile);
    await imageUploadTask.whenComplete((){print('Image Uploaded');});

    await imageReference.getDownloadURL().then((value){
      Provider.of<CreateWorkoutUtils>(context, listen: false).thumbnailUrl = value.toString();
      print('the Thumbnail Image url => ${Provider.of<CreateWorkoutUtils>(context, listen: false).thumbnailUrl}');
      Provider.of<CreateWorkoutUtils>(context, listen: false).changeThumbnailSelected(true);
      notifyListeners();
    });

    Provider.of<CreateWorkoutUtils>(context, listen: false).changeUploadState(false);
  }

  
  Future createUserCollection(BuildContext context, dynamic data) async{
    return FirebaseFirestore.instance.collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future initProfileData(BuildContext context) async {
    print('Fetching User Data');
    try {
      dynamic doc = await FirebaseFirestore.instance.collection('users')
          .doc(Provider.of<Authentication>(context, listen: false).getUserUid).get();
      print('User data fetched');
      profileDataStream(context);
      notifyListeners();
      return doc;
    } catch (error){
      print('Could not fetch user data');
      throw error;
    }
  }

  Future updateProfileData(BuildContext context, dynamic data) async {
    await FirebaseFirestore.instance.collection('users')
      .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
      .update(data);
  }

  void profileDataStream(BuildContext context) async {
    await for (var snapshot in FirebaseFirestore.instance.collection('users').doc(Provider.of<Authentication>(context, listen: false).getUserUid).snapshots()){
      Provider.of<HomeScreenHelpers>(context, listen:false).updateProfileData(snapshot);
    }
  }

}