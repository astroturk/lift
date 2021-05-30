import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/model/user.dart';
import 'package:lift/screens/comments_screen/comments_screen.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';
import 'package:lift/services/authentication.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  final String workoutId;
  final String ownerId;
  final String username;
  final String description;
  final String thumbnailUrl;
  final dynamic likes;

  Post ({
    this.workoutId,
    this.ownerId,
    this.username,
    this.description,
    this.thumbnailUrl,
    this.likes,
  });

  factory Post.fromDocument(dynamic doc) {
    return Post(
      workoutId: doc['workout_id'],
      ownerId: doc['user_uid'],
      username: doc['user_name'],
      description: doc['description'],
      thumbnailUrl: doc['thumbnail_url'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes){
    if (likes == null) return 0;
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
    workoutId: this.workoutId,
    ownerId: this.ownerId,
    username: this.username,
    description: this.description,
    thumbnailUrl: this.thumbnailUrl,
    likes: this.likes,
    likeCount: getLikeCount(this.likes),
  );
}

class _PostState extends State<Post> {
  final String workoutId;
  final String ownerId;
  final String username;
  final String description;
  final String thumbnailUrl;
  Map likes;
  int likeCount;
  bool isLiked;
  bool showHeart = false;

  _PostState({
    this.workoutId,
    this.ownerId,
    this.username,
    this.description,
    this.thumbnailUrl,
    this.likes,
    this.likeCount
  });

  buildPostHeader() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: SpinKitDoubleBounce(
                color: Colors.white,
                size: 40.0,
              ),
            ),
          );
        }

        User user = User.fromDocument(snapshot.data.data());
        return ListTile(
          tileColor: SpecialDarkGrey,
          contentPadding: EdgeInsets.only(left: 10),
          minLeadingWidth: 5,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
            backgroundColor: Colors.grey,
            radius: 18,
          ),
          title: GestureDetector(
            onTap: () => print('Show Profile'),
            child: Text(
              user.username,
              style: TextSmallWhite,
            ),
          ),
          trailing: IconButton(
            onPressed: () => print('Deleting Post'),
            icon: Icon(Icons.more_vert),
            iconSize: 22,
          ),
        );
      }
    );
  }

  buildPostImage(){
    return GestureDetector(
      onDoubleTap: () => handleLikePost(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(thumbnailUrl),
          showHeart ? Icon(Icons.favorite, size: 100.0, color: Colors.red,) : Text(""),
        ],
      ),
    );
  }

  handleLikePost(){
    String currentUser = Provider.of<Authentication>(context, listen: false).getUserUid;
    bool _isLiked = likes[currentUser] == true;

    print(workoutId);
    if (_isLiked) {
      FirebaseFirestore.instance.collection('workouts')
        .doc(ownerId)
        .collection('userWorkouts')
        .doc(workoutId)
        .update({'likes.$currentUser': false,});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUser] = false;
      });
    } else if(!_isLiked) {
      addLikeToActivityFeed();
      FirebaseFirestore.instance.collection('workouts')
        .doc(ownerId)
        .collection('userWorkouts')
        .doc(workoutId)
        .update({'likes.$currentUser': true,});
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUser] = true;
        showHeart = true;

      });
      Timer(Duration(milliseconds: 500), (){
        setState(() {
          showHeart= false;
        });
      });
    }
  }
  
  addLikeToActivityFeed(){
    bool isNotPostOwner = (ownerId != Provider.of<Authentication>(context, listen: false).getUserUid);
    if (isNotPostOwner){
      FirebaseFirestore.instance.collection('feed')
          .doc(ownerId)
          .collection('feedItems')
          .doc(workoutId)
          .set({
        "type": "like",
        "username": Provider.of<HomeScreenHelpers>(context, listen: false).getUserName,
        "userId": Provider.of<Authentication>(context, listen: false).getUserUid,
        "userProfileImage": Provider.of<HomeScreenHelpers>(context, listen: false).getImage,
        "workoutId": workoutId,
        "ownerId": ownerId,
        "thumbnailUrl":thumbnailUrl,
        "timestamp": DateTime.now(),
      });
    }
  }

  removeLikeFromActivityFeed(){
    bool isNotPostOwner = (ownerId != Provider.of<Authentication>(context, listen: false).getUserUid);
    if (isNotPostOwner){
      FirebaseFirestore.instance.collection('feed')
        .doc(ownerId)
        .collection('feedItems')
        .doc(workoutId)
        .get()
        .then(
            (doc){
          if (doc.exists) {doc.reference.delete();}
        });
    }
  }


  buildPostFooter() {
    return Container(
      color: SpecialDarkGrey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: GestureDetector(
                  onTap: () => handleLikePost(),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 28,
                    color: Colors.pink,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: GestureDetector(
                  onTap: () => showComments(
                    context,
                    workoutId: workoutId,
                    ownerId: ownerId,
                    thumbnailUrl: thumbnailUrl,
                  ),
                  child: Icon(
                    Icons.chat,
                    size: 28,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              SizedBox(width: 15,),
              Container(
                child: Text(
                  '$likeCount likes',
                  style: TextSmallWhite.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 10,),
              Container(
                child: Text(
                  '$description',
                  style: TextSmallWhite,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[Provider.of<Authentication>(context, listen: false).getUserUid] == true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
        SizedBox(height: 10,)
      ],
    );
  }
}

showComments(BuildContext context, { String workoutId, String ownerId, String thumbnailUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
      workoutId: workoutId,
      workoutOwnerId: ownerId,
      workoutThumbnailUrl: thumbnailUrl,
    );
  }));
}