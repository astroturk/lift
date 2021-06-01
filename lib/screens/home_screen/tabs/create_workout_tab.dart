import 'package:flutter/material.dart';
import 'package:lift/components/custom_alert_dialog_box.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';
import 'package:lift/services/workouts.dart';
import 'package:lift/screens/home_screen/tabs/add_step_tab.dart';
import 'package:provider/provider.dart';
import 'loading_tab.dart';
import '../tab_helpers/workout_list.dart';

class CreateWorkoutTab extends StatefulWidget {
  const CreateWorkoutTab({Key key}) : super(key: key);

  @override
  _CreateWorkoutTabState createState() => _CreateWorkoutTabState();
}

class _CreateWorkoutTabState extends State<CreateWorkoutTab> {
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    Widget bodyCurrent(bool dataFetched){
      if(dataFetched) return WorkoutList();
      else return LoadingTab();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          'Create Workout',
          style: TextTabTitle,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            iconSize: 25,
            onPressed: () {
              Provider.of<Workouts>(context, listen: false).createNewWorkout(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: bodyCurrent(Provider.of<HomeScreenHelpers>(context).profileDataFetched),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10,),
                  CreateWorkoutButton(
                    onPressed: (){Navigator.pushNamed(context, AddStepTab.id);},
                    text: 'Add',
                  ),
                  SizedBox(width: 10,),
                  CreateWorkoutButton(
                    onPressed: isUploading ? (){} : (){
                      setState(() {
                        isUploading = true;
                      });
                      try {
                        Provider.of<Workouts>(context, listen: false)
                            .saveCurrentWorkout(context);
                      } catch (error) {
                        showDialog(
                          context: context,
                          builder: (context) => CustomAlertDialogBox(
                            context: context,
                            title: 'Error',
                            message: 'Could not save workout',
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
                      setState(() {
                        isUploading = false;
                      });
                    },
                    text: 'Save',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CreateWorkoutButton(
                    onPressed: (){},
                    text: 'Post',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CreateWorkoutButton extends StatelessWidget {
  final text;
  final onPressed;
  CreateWorkoutButton({this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(SpecialPurple),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)))
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextButtonWhite,
        ),
      ),
    );
  }
}
