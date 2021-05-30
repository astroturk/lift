import 'package:flutter/material.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/model/post.dart';
import 'package:lift/screens/post_screen/post_screen.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  showPost(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostScreen(
              workoutId: post.workoutId,
              userId: post.ownerId,
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: Container(
        color: SpecialGrey,
        child: Image(
          image: NetworkImage(post.thumbnailUrl),
        ),
      )
    );
  }
}
