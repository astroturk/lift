import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift/components/form_input.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/services/workouts.dart';
import 'package:lift/screens/home_screen/tab_helpers/create_workout_utils.dart';
import 'package:provider/provider.dart';

class WorkoutList extends StatefulWidget {
  @override
  _WorkoutListState createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {

  List <Widget> workoutSteps(List<WorkoutStep> steps, BuildContext context){
    List <Widget> stepCards = [
      ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: ExpansionTile(
          initiallyExpanded: false,
          title: Text(
            'Workout Panel',
            style: TextMediumGreen.copyWith(fontSize: 17),
          ),
          backgroundColor: SpecialGrey,
          collapsedBackgroundColor: SpecialGrey,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ImageSelectingInterface(),
                  SizedBox(height: 10,),
                  TextFormField(
                    textAlign: TextAlign.left,
                    onChanged: (value){ Provider.of<CreateWorkoutUtils>(context, listen: false).title = value;},
                    decoration: formInputDecoration.copyWith(labelText: 'Title'),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                          onChanged: (value){
                            if (value != '')Provider.of<CreateWorkoutUtils>(context, listen: false).hours = int.parse(value);
                            else Provider.of<CreateWorkoutUtils>(context, listen: false).hours = 0;
                          },
                          decoration: formInputDecoration.copyWith(labelText: 'Hour'),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                          onChanged: (value){
                            if (value != '')Provider.of<CreateWorkoutUtils>(context, listen: false).minutes = int.parse(value);
                            else Provider.of<CreateWorkoutUtils>(context, listen: false).minutes = 0;
                          },
                          decoration: formInputDecoration.copyWith(labelText: 'Min'),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                          onChanged: (value){
                            if (value != '')Provider.of<CreateWorkoutUtils>(context, listen: false).seconds = int.parse(value);
                            else Provider.of<CreateWorkoutUtils>(context, listen: false).seconds = 0;
                          },
                          decoration: formInputDecoration.copyWith(labelText: 'Sec'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    textAlign: TextAlign.left,
                    onChanged: (value){ Provider.of<CreateWorkoutUtils>(context, listen: false).description = value;},
                    decoration: formInputDecoration.copyWith(labelText: 'Description'),
                  ),
                  SizedBox(height: 10,),
                  NavigationButton(
                    onPressed: Provider.of<CreateWorkoutUtils>(context).getImageUploadState ? (){} : (){
                      Provider.of<CreateWorkoutUtils>(context, listen: false).updateWorkoutInfo(context);
                    },
                    text: 'Update',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      WorkoutInformationCard(),
    ];
    for (int i = 0; i < steps.length; i++){
      stepCards.add(StepCard(
        step: steps[i],
        index: i,
      ));
    }
    return stepCards;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: workoutSteps(Provider.of<Workouts>(context).currentWorkout.steps, context),
    );
  }
}

class WorkoutInformationCard extends StatefulWidget {
  const WorkoutInformationCard({Key key}) : super(key: key);

  @override
  _WorkoutInformationCardState createState() => _WorkoutInformationCardState();
}

class _WorkoutInformationCardState extends State<WorkoutInformationCard> {
  Widget getThumbnailPhoto(bool thumbnailState) {
    if (thumbnailState) return Image(image: NetworkImage(Provider.of<CreateWorkoutUtils>(context, listen: false).getThumbnailUrl),);
    else return Image.asset('images/default.png');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Container(
        decoration: BoxDecoration(
          color: SpecialGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 150,
              padding: EdgeInsets.all(10),
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: getThumbnailPhoto(Provider.of<CreateWorkoutUtils>(context).getThumbnailUrl != ''),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          child: Text(
                            Provider.of<CreateWorkoutUtils>(context).getTitle,
                            style: TextSmallGreen.copyWith(fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 2,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                          child: Text(
                            Provider.of<CreateWorkoutUtils>(context).getDescription,
                            style: TextSmallWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
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
  dynamic thumbnailDisplay(bool imageSelected){
    if (!imageSelected) return AssetImage('images/default.png');
    else return NetworkImage(Provider.of<CreateWorkoutUtils>(context, listen: false).thumbnailUrl);
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
                image: thumbnailDisplay(Provider.of<CreateWorkoutUtils>(context).thumbnailSelected),
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
                  onPressed: (){
                    Provider.of<CreateWorkoutUtils>(context, listen: false).changeUploadState(true);
                    Provider.of<CreateWorkoutUtils>(context, listen: false).pickThumbnail(context, ImageSource.gallery);
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

class StepCard extends StatelessWidget {
  final WorkoutStep step;
  final int index;
  StepCard({@required this.step, @required this.index});

  Widget stepTypeCard(){
    if (step.type == 'Timed') return TimedCard(
      subtext: Duration(seconds: step.duration).toString().split('.')[0],
    );
    else if (step.type == 'Repetition') return RepetitionCard(
      subtext: step.reps.toString() + ' Reps',
    );
    else return RestCard(
      subtext: Duration(seconds: step.duration).toString().split('.')[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: SpecialDarkGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(5),
                  child: Image(
                    image: NetworkImage(step.imageUrl),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: SpecialDarkGrey,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    )
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 2,
                            ),
                            stepTypeCard(),
                            SizedBox(
                              height: 1,
                              child: Container(
                                color: SpecialGreen,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              step.message,
                              style: TextStepCardBody,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: (){},
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: (){
                                  print(index);
                                  Provider.of<Workouts>(context, listen: false).deleteWorkoutStep(context, index);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}

class TimedCard extends StatelessWidget {
  final subtext;
  TimedCard({this.subtext});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkoutType(
            text: 'Timed',
            icon: Icons.timer,
            subtext: subtext,
          ),
        ],
      ),
    );
  }
}

class RepetitionCard extends StatelessWidget {
  final String subtext;
  RepetitionCard({this.subtext});
  @override
  Widget build(BuildContext context) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkoutType(
          text: 'Repetition',
          icon: Icons.repeat,
          subtext: subtext,
        ),
      ],
    ),
  );
  }
}

class RestCard extends StatelessWidget {
  final subtext;
  RestCard({this.subtext});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkoutType(
            text: 'Rest',
            icon: Icons.battery_alert,
            subtext: subtext,
          ),
        ],
      ),
    );
  }
}

class WorkoutType extends StatelessWidget {
  final String text;
  final String subtext;
  final IconData icon;
  WorkoutType({this.text, this.icon, this.subtext});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(
                icon,
                size: 18,
                color: SpecialGreen,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: TextStepCardTitle,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                subtext,
                style: TextStepCardTitle,
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ]
      ),
    );
  }
}
