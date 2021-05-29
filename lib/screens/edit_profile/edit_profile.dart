import 'package:flutter/material.dart';
import 'package:lift/components/custom_alert_dialog_box.dart';
import 'package:lift/components/form_input.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';
import 'package:lift/services/authentication.dart';
import 'package:lift/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String newUsername = '';
  String newBio = '';

  Future updateProfileData() async {
    if (newUsername.length < 3 || newUsername.length > 30 || newBio.length > 100)
      throw 'Please enter valid Profile Data';
    dynamic data = {
      'user_name': newUsername,
      'user_bio' : newBio,
    };
    await Provider.of<FirebaseOperations>(context, listen: false).updateProfileData(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: SpecialPurple,
        title: Text(
          'Edit Profile',
          style: TextTabTitle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              size: 25,
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(Provider.of<HomeScreenHelpers>(context).getImage),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormInput(
                    onChange: (value){
                      newUsername = value;
                    },
                    labelText: 'Username',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormInput(
                    onChange: (value){
                      newBio = value;
                    },
                    labelText: 'Bio',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width,
                    child: NavigationButton(
                      onPressed: () async {
                        try {
                          await updateProfileData();
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialogBox(
                              context: context,
                              title: 'Success',
                              message: 'Profile Data Updated',
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
                        catch (error) {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialogBox(
                              context: context,
                              title: 'Error',
                              message: 'Could Update User Data',
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
                      },
                      text: 'Update',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      size: 35,
                    ),
                    onPressed: () async {
                      try {
                        await Provider.of<Authentication>(context, listen: false)
                            .logOutAccount(context);
                      } catch(error){
                        showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialogBox(
                              context: context,
                              title: 'Error',
                              message: 'Could Not Log Out User',
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK', style: TextMediumGreen, ),
                                ),
                              ],
                            )
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
