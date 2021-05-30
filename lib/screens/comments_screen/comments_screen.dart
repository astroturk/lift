import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lift/components/form_input.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';
import 'package:lift/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('comments')
          .doc(workoutId).collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return Container(
            child: Center(
              child: SpinKitDoubleBounce(
                color: Colors.white,
                size: 40.0,
              ),
            ),
          );
        }
        List<Comment> comments = [];
        snapshot.data.docs.forEach((doc){comments.add(Comment.fromDocument(doc.data()));});
        return ListView(
          children: comments,
        );

        /*return ListView(
          children: comments,
        );*/
      },
    );
  }

  addComment() {
    FirebaseFirestore.instance.collection('comments')
      .doc(workoutId)
      .collection("comments")
      .add({
        'username': Provider.of<HomeScreenHelpers>(context, listen: false).getUserName,
        'comment': commentController.text,
        'timestamp': DateTime.now(),
        'avatarUrl': Provider.of<HomeScreenHelpers>(context, listen: false).getImage,
        'user_id': Provider.of<Authentication>(context, listen: false).getUserUid,
      });
    FirebaseFirestore.instance.collection('feed')
      .doc(workoutOwnerId)
      .collection('feedItems')
      .add({
        "type": "comment",
        "commentData": commentController.text,
        "username": Provider.of<HomeScreenHelpers>(context, listen: false).getUserName,
        "userId": Provider.of<Authentication>(context, listen: false).getUserUid,
        "userProfileImage": Provider.of<HomeScreenHelpers>(context, listen: false).getImage,
        "workoutId": workoutId,
        "ownerId": workoutOwnerId,
        "thumbnailUrl": workoutThumbnailUrl,
        "timestamp": DateTime.now(),
      });
    commentController.clear();
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
                  onPressed: () => addComment(),
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

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(dynamic doc) {
    return Comment(
      username: doc['username'],
      userId: doc['user_id'],
      comment: doc['comment'],
      avatarUrl: doc['avatarUrl'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}