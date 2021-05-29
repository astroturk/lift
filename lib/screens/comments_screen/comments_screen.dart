import 'package:flutter/material.dart';
import 'package:lift/components/form_input.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/constants/constants.dart';

class Comments extends StatefulWidget {
  final String workoutId;
  final String workoutOwnerId;
  final String workoutThumbnailUrl;

  Comments({
    this.workoutId,
    this.workoutOwnerId,
    this.workoutThumbnailUrl,
  });

  @override
  _CommentsState createState() => _CommentsState(
    workoutId: this.workoutId,
    workoutOwnerId: this.workoutOwnerId,
    workoutThumbnailUrl: this.workoutThumbnailUrl
  );
}

class _CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String workoutId;
  final String workoutOwnerId;
  final String workoutThumbnailUrl;

  _CommentsState({
    this.workoutId,
    this.workoutOwnerId,
    this.workoutThumbnailUrl,
  });

  buildComments() {
    return Text("Comments");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Comments',
          style: TextTabTitle,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildComments(),
          ),
          Divider(),
          Container(
            color: SpecialDarkGrey,
            child: ListTile(
              contentPadding: EdgeInsets.only(right: 10),
              horizontalTitleGap: 0,
              title: Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: commentController,
                  decoration: formInputDecoration.copyWith().copyWith(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                    isDense: true
                  ),
                ),
              ),
              trailing: SizedBox(
                width: 100,
                child: NavigationButton(
                  onPressed: (){},
                  text: 'Submit',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
