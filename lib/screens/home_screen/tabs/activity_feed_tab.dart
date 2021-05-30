import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/post_screen/post_screen.dart';
import 'package:lift/screens/profile_screen/profile_screen.dart';
import 'package:lift/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedTab extends StatefulWidget {
  const ActivityFeedTab({Key key}) : super(key: key);

  @override
  _ActivityFeedTabState createState() => _ActivityFeedTabState();
}

class _ActivityFeedTabState extends State<ActivityFeedTab> {
  getActivityFeed() async {
    dynamic snapshot = await FirebaseFirestore.instance.collection('feed')
      .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
      .collection('feedItems')
      .orderBy('timestamp', descending: true)
      .limit(50)
      .get();
    List<ActivityFeedItem> feedItems = [];
    snapshot.docs.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc.data()));
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 15,
        title: Text(
          'Feed',
          style: TextTabTitle,
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getActivityFeed(),
          builder: (context, snapshot){
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
            return ListView(
              children: snapshot.data,
            );
          },
        ),
      ),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type;
  final String thumbnailUrl;
  final String workoutId;
  final String userProfileImage;
  final String commentData;
  final Timestamp timestamp;
  final String ownerId;

  ActivityFeedItem({
    this.username,
    this.userId,
    this.type,
    this.thumbnailUrl,
    this.workoutId,
    this.userProfileImage,
    this.commentData,
    this.timestamp,
    this.ownerId,
  });

  factory ActivityFeedItem.fromDocument(dynamic doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      workoutId: doc['workoutId'],
      userProfileImage: doc['userProfileImage'],
      thumbnailUrl: doc['thumbnailUrl'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
      ownerId: doc['ownerId'],
    );
  }
  
  showPost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(workoutId: workoutId, userId: ownerId,)
      )
    );
  }

  configureMediaPreview(BuildContext context) {
    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(thumbnailUrl),
                )
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'like'){
      activityItemText = 'liked Your Post';
    } else if (type == 'follow') {
      activityItemText = 'is following you';
    } else if (type == 'comment') {
      activityItemText = 'replied: $commentData';
    } else {
      activityItemText = 'Error: Unknown type $type';
    }
  }

  showProfile(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(userId: userId,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.black,
        child: ListTile(
          title: GestureDetector(
            onTap: () => showProfile(context),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: username,
                  ),
                  TextSpan(
                    text: ' $activityItemText',
                  )
                ]
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: SpecialDarkGrey,
            backgroundImage: NetworkImage(userProfileImage),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

