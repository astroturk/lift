import 'package:flutter/material.dart';
import 'package:lift/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class HomeScreenHelpers with ChangeNotifier{
  bool profileDataFetched = false;
  bool profileDataFetchingError = false;
  String userName;
  String email;
  String image;
  String fullName;
  String bio;

  String get getUserName => userName;
  String get getEmail => email;
  String get getImage => image;
  String get getFullName => fullName;

  Future fetchProfileData(BuildContext context) async {
    profileDataFetched = false;
    profileDataFetchingError = false;
    notifyListeners();

    try {
      dynamic doc = await Provider.of<FirebaseOperations>(context, listen: false)
          .initProfileData(context);
      userName = doc.data()['user_name'];
      email = doc.data()['user_email'];
      image = doc.data()['user_image'];
      fullName = doc.data()['user_full_name'];
      bio = doc.data()['user_bio'];
      print('Values Updated');
      profileDataFetched = true;
      profileDataFetchingError = false;
    } catch (error) {
      print('Values Updated');
      profileDataFetched = false;
      profileDataFetchingError = true;
    }
    print('Listeners Notified');
    notifyListeners();
  }

  void updateProfileData(dynamic doc) {
    userName = doc.data()['user_name'];
    email = doc.data()['user_email'];
    image = doc.data()['user_image'];
    fullName = doc.data()['user_full_name'];
    bio = doc.data()['user_bio'];
    notifyListeners();
  }
}