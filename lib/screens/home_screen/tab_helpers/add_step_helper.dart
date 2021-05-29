import 'package:flutter/material.dart';

class AddStepHelper extends ChangeNotifier {
  bool imageUploading = false;
  bool get getImageUploadState => imageUploading;

  void changeUploadState(bool current) {
    imageUploading = current;
    notifyListeners();
  }
}