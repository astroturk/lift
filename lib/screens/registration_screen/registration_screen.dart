import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/components/form_input.dart';
import 'package:lift/components/custom_alert_dialog_box.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/home_screen/home_screen.dart';
import 'package:lift/screens/registration_screen/registration_utils.dart';
import 'package:lift/services/firebase_operations.dart';
import 'package:provider/provider.dart';
import 'package:lift/services/authentication.dart';
import 'registration_utils.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email = '';
  String password = '';
  String name = '';
  String fullName = '';
  bool isEnabled = true;

  // Handle pressing navigation button
  void validator() {
    if (fullName == '' || password == '' || name  == '' || email == '') throw 'Please complete all fields';
  }

  void handleSubmit(BuildContext context) async {
    // Set imageUrl to default image if null
    String imageUrl = Provider.of<RegisterUtils>(context, listen: false).getUserAvatarUrl;
    if (imageUrl == null) imageUrl = 'https://firebasestorage.googleapis.com/v0/b/lift-604d3.appspot.com/o/assets%2Fdefault.png?alt=media&token=efcd64c9-871c-4816-b526-71dbafaa7960';

    try {
      validator();

      print('Creating New Account');
      await Provider.of<Authentication>(context, listen: false)
          .createNewAccount(email, password);

      print('Creating User Collection');
      await Provider.of<FirebaseOperations>(context, listen: false).createUserCollection(context, {
        'user_uid': Provider.of<Authentication>(context, listen: false).getUserUid,
        'user_full_name': fullName,
        'user_email': email,
        'user_name': name,
        'user_image': imageUrl,
      });
      Navigator.pushNamed(context, HomeScreen.id);
    } catch (error){
      print(error);
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialogBox(
          context: context,
          title: 'Error',
          message: 'Could Not Create User',
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text(
                'OK',
                style: TextMediumGreen,
              ),
            ),
          ],
        ),
      );
    }
  }

  dynamic profileImageDisplay(bool avatarSelected){
    if (!avatarSelected) return AssetImage('images/default.png');
    else return FileImage(Provider.of<RegisterUtils>(context, listen: false).userAvatar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: SpecialPurple,
        title: Text(
          'LIFT',
          style: TextTitleWhite,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: profileImageDisplay(Provider.of<RegisterUtils>(context).avatarSelected),
                                radius: 50,
                              ),
                              CircleAvatar(
                                backgroundColor: SpecialPurple,
                                child: IconButton(
                                  icon: const Icon(Icons.insert_photo),
                                  color: Colors.white,
                                  onPressed: () {
                                      Provider.of<RegisterUtils>(
                                          context, listen: false)
                                          .pickUserAvatar(
                                          context, ImageSource.gallery);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          Column(
                            children: [
                              Text(
                                'Create Your',
                                style: TextLargePurple,
                              ),
                              Text(
                                'Account!',
                                style: TextLargePurple,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FormInput(
                        onChange: (value) {
                          fullName = value;
                        },
                        labelText: 'Full Name',
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      FormInput(
                        onChange: (value) {
                          name = value;
                        },
                        labelText: 'Username',
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      FormInput(
                        onChange: (value) {
                          email = value;
                        },
                        labelText: 'Email',
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      FormInput(
                        onChange: (value) {
                          password = value;
                        },
                        obscureText: true,
                        labelText: 'Password',
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      NavigationButton(
                        onPressed: Provider.of<RegisterUtils>(context).getImageUploadState ? () {} : (){ handleSubmit(context); } ,
                        text: 'Register',
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
