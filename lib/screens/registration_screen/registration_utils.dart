import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class RegisterUtils with ChangeNotifier {
  final picker  = ImagePicker();
  bool imageUploading = false;
  bool avatarSelected = false;
  File userAvatar;
  File get getUserAvatar => userAvatar;
  String userAvatarUrl;
  String get getUserAvatarUrl => userAvatarUrl;
  bool get getImageUploadState => imageUploading;

  void changeUploadState(bool current){
    imageUploading = current;
    notifyListeners();
  }

  void changeAvatarSelected(bool currentState) {
    avatarSelected = currentState;
    notifyListeners();
  }

  Future pickUserAvatar(BuildContext context, ImageSource source) async{
    imageUploading = true;
    final pickerUserAvatar = await picker.getImage(source: source);

    if (pickerUserAvatar ==  null){
      print('Please Select an Image');
      imageUploading = false;
      return;
    }
    else userAvatar = File(pickerUserAvatar.path);

    print("Avatar Path Chosen By User : " + userAvatar.path);

    if (userAvatar != null) Provider.of<FirebaseOperations>(context, listen: false).uploadUserAvatar(context);
    else print('Image Upload Error');
    notifyListeners();
  }
}