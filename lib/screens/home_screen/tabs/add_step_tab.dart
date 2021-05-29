import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift/constants/constants.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:lift/components/form_input.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/screens/home_screen/tab_helpers/add_step_helper.dart';
import 'package:provider/provider.dart';
import 'package:lift/services/workouts.dart';

class AddStepTab extends StatefulWidget {
  static String id = 'add_step_tab';
  const AddStepTab({Key key}) : super(key: key);

  @override
  _AddStepTabState createState() => _AddStepTabState();
}

class _AddStepTabState extends State<AddStepTab> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Timed'),
              Tab(text: 'Repetition'),
              Tab(text: 'Rest'),
            ],
            labelStyle: TextButtonWhite.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
            indicator: BubbleTabIndicator(
              indicatorHeight: 40.0,
              indicatorColor: SpecialPurple,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            TimedWorkoutInput(),
            RepetitionWorkoutInput(),
            RestWorkoutInput(),
          ],
        ),
      ),
    );
  }
}

class TimedWorkoutInput extends StatefulWidget {
  const TimedWorkoutInput({Key key}) : super(key: key);

  @override
  _TimedWorkoutInputState createState() => _TimedWorkoutInputState();
}

class _TimedWorkoutInputState extends State<TimedWorkoutInput> {
  int seconds = 0;
  int minutes = 0;
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageSelectingInterface(),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: FormNumberInput(
                    onChange: (value){
                      minutes = int.parse(value);
                    },
                    labelText: 'Minutes',
                    ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: FormNumberInput(
                    onChange: (value){
                      seconds = int.parse(value);
                    },
                    labelText: 'Seconds',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            FormInput(
              onChange: (value){
                message = value;
              },
              labelText: 'Message',
            ),
            SizedBox(height: 5,),
            NavigationButton(
              onPressed: Provider.of<AddStepHelper>(context).getImageUploadState ? (){} : (){
                var step = WorkoutStep();
                step.type = 'Timed';
                step.message = message;
                step.duration = Duration(seconds: seconds, minutes: minutes).inSeconds;
                step.imageUrl = Provider.of<Workouts>(context, listen: false).getStepImageUrl;
                Provider.of<Workouts>(context, listen: false).addWorkoutStep(context, step);
              },
              text: 'Add Task',
            ),
          ],
        ),
      ),
    );
  }
}

class RepetitionWorkoutInput extends StatefulWidget {
  const RepetitionWorkoutInput({Key key}) : super(key: key);

  @override
  _RepetitionWorkoutInputState createState() => _RepetitionWorkoutInputState();
}

class _RepetitionWorkoutInputState extends State<RepetitionWorkoutInput> {
  int repetitions = 0;
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageSelectingInterface(),
            SizedBox(height: 10,),
            FormNumberInput(
              onChange: (value){
                repetitions = int.parse(value);
              },
              labelText: 'Repetition',
            ),
            SizedBox(height: 10,),
            FormInput(
              onChange: (value){
                message = value;
              },
              labelText: 'Message',
            ),
            SizedBox(height: 5,),
            NavigationButton(
              onPressed:Provider.of<AddStepHelper>(context).getImageUploadState ? (){} : (){
                var step = WorkoutStep();
                step.type = 'Repetition';
                step.reps = repetitions;
                step.message = message;
                step.imageUrl = Provider.of<Workouts>(context, listen: false).getStepImageUrl;
                Provider.of<Workouts>(context, listen: false).addWorkoutStep(context, step);
              },
              text: 'Add Task',
            ),
          ],
        ),
      ),
    );
  }
}

class RestWorkoutInput extends StatefulWidget {
  const RestWorkoutInput({Key key}) : super(key: key);

  @override
  _RestWorkoutInputState createState() => _RestWorkoutInputState();
}

class _RestWorkoutInputState extends State<RestWorkoutInput> {
  int seconds = 0;
  int minutes = 0;
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageSelectingInterface(),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: FormNumberInput(
                    onChange: (value){
                      minutes = int.parse(value);
                    },
                    labelText: 'Minutes',
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: FormNumberInput(
                    onChange: (value){
                      seconds = int.parse(value);
                    },
                    labelText: 'Seconds',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            FormInput(
              onChange: (value){
                message = value;
              },
              labelText: 'Message',
            ),
            SizedBox(height: 5,),
            NavigationButton(
              onPressed: Provider.of<AddStepHelper>(context).getImageUploadState ? (){} : (){
                var step = WorkoutStep();
                step.type = 'Rest';
                step.message = message;
                step.duration = Duration(seconds: seconds, minutes: minutes).inSeconds;
                step.imageUrl = Provider.of<Workouts>(context, listen: false).getStepImageUrl;
                Provider.of<Workouts>(context, listen: false).addWorkoutStep(context, step);
              },
              text: 'Add Task',
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSelectingInterface extends StatefulWidget {
  const ImageSelectingInterface({Key key}) : super(key: key);

  @override
  _ImageSelectingInterfaceState createState() => _ImageSelectingInterfaceState();
}

class _ImageSelectingInterfaceState extends State<ImageSelectingInterface> {
  dynamic stepImageDisplay(bool imageSelected){
    if (!imageSelected) return AssetImage('images/default.png');
    else return FileImage(Provider.of<Workouts>(context, listen: false).getStepImage);
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image(
                image: stepImageDisplay(Provider.of<Workouts>(context).stepImageSelected),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ImageSelectionButton(
                  text: 'Gallery',
                  icon: Icons.photo_library,
                  onPressed: () async {
                    Provider.of<AddStepHelper>(context, listen: false).changeUploadState(true);
                    Provider.of<Workouts>(context, listen: false).pickStepImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageSelectionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final onPressed;
  ImageSelectionButton({@required this.text, @required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(SpecialPurple),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextButtonWhite.copyWith(fontSize: 17),
          ),
        ],
      )
    );
  }
}

