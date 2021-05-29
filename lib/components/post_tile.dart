import 'package:flutter/material.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/model/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Showing Post'),
      child: Container(
        color: SpecialGrey,
        child: Image(
          image: NetworkImage(post.thumbnailUrl),
        ),
      )
    );
  }
}
