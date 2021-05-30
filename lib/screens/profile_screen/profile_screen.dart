import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/components/post_tile.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/model/post.dart';
import 'package:lift/model/user.dart';
import 'package:lift/screens/edit_profile/edit_profile.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';
import 'package:lift/services/authentication.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final userId;
  ProfileScreen({
    this.userId,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState(
    userId: this.userId
  );
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userId;
  _ProfileScreenState({
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextTabTitle,
        ),
      ),
      body: ProfileBody(userId: userId,),
    );
  }
}

class ProfileBody extends StatefulWidget {
  final String userId;
  ProfileBody({this.userId});

  @override
  _ProfileBodyState createState() => _ProfileBodyState(
    userId: this.userId,
  );
}

class _ProfileBodyState extends State<ProfileBody> {
  bool isFollowing = false;
  final String userId;
  bool isLoading = false;
  int workoutCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];
  String postOrientation = "Grid";

  _ProfileBodyState({this.userId});

  showProfileButtons(){
    if (userId == Provider.of<Authentication>(context, listen:false).getUserUid){
      return NavigationButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
        },
        text: 'Edit Profile',
      );
    }
    else if (isFollowing) {
      return NavigationButton(
        onPressed: () => handleUnfollowUser(),
        text: 'Unfollow',
      );
    }
    else {
      return NavigationButton (
        onPressed: () => handleFollowUser(),
        text: 'Follow',
      );
    }
  }

  handleUnfollowUser() {
    String currentUserId = Provider.of<Authentication>(context, listen: false).getUserUid;
    setState(() {isFollowing = false;});
    FirebaseFirestore.instance.collection('followers')
      .doc(userId)
      .collection('userFollowers')
      .doc(currentUserId)
      .get().then((doc){
        if(doc.exists) {
          doc.reference.delete();
        }
      });
    FirebaseFirestore.instance.collection('following')
      .doc(currentUserId)
      .collection('userFollowing')
      .doc(userId)
      .get().then((doc){
        if(doc.exists) {
          doc.reference.delete();
        }
      });
    FirebaseFirestore.instance.collection('feed')
      .doc(userId)
      .collection('feedItems')
      .doc(currentUserId)
      .get().then((doc){
        if(doc.exists) {
          doc.reference.delete();
        }
      });
  }

  handleFollowUser() {
    String currentUserId = Provider.of<Authentication>(context, listen: false).getUserUid;
    setState(() {isFollowing = true;});
    FirebaseFirestore.instance.collection('followers')
      .doc(userId)
      .collection('userFollowers')
      .doc(currentUserId)
      .set({});
    FirebaseFirestore.instance.collection('following')
      .doc(currentUserId)
      .collection('userFollowing')
      .doc(userId)
      .set({});
    FirebaseFirestore.instance.collection('feed')
      .doc(userId)
      .collection('feedItems')
      .doc(currentUserId)
      .set({
        "type" : "follow",
        "ownerId": userId,
        "username": Provider.of<HomeScreenHelpers>(context, listen: false).getFullName,
        "userId": currentUserId,
        "userProfileImage": Provider.of<HomeScreenHelpers>(context, listen: false).getImage,
        "timestamp" : DateTime.now(),
      });
  }

  buildProfileHeader(){
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SpinKitDoubleBounce(
            color: Colors.white,
            size: 40.0,
          );
        }
        User user;
        user = User.fromDocument(snapshot.data.data());
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            ProfileInfoCard(
                              text: 'Workouts',
                              count: workoutCount.toString(),
                            ),
                            ProfileInfoCard(
                              text: 'Following',
                              count: followingCount.toString(),
                            ),
                            ProfileInfoCard(
                              text: 'Followers',
                              count: followerCount.toString(),
                            ),
                          ],
                        ),
                        showProfileButtons(),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: TextProfile.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      user.fullName,
                      style: TextProfile.copyWith(fontWeight: FontWeight.w100),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      user.bio == null ? '' : user.bio,
                      style: TextProfile,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('followers')
      .doc(userId)
      .collection('userFollowers')
      .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
      .get();
    print(doc.exists);
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('followers')
      .doc(userId)
      .collection('userFollowers')
      .get();
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('following')
        .doc(userId)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getFollowers();
    getFollowing();
    getProfilePosts();
    checkIfFollowing();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('workouts')
      .doc(userId)
      .collection('userWorkouts')
      .get();

    setState(() {
      isLoading = false;
      workoutCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc.data())).toList();
    });
  }

  buildProfilePosts() {
    if (isLoading) {
      return Container(
        child: Center(
          child: SpinKitDoubleBounce(
            color: Colors.white,
            size: 40.0,
          ),
        ),
      );
    }
    else if (postOrientation == 'Grid'){
      List <GridTile> gridTiles = [];
      posts.forEach((post) {
        gridTiles.add(GridTile(child:PostTile(post)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    }
    return Column(children: posts,);
  }

  buildToggleProfileOrientation() {
    return Container(
      color: SpecialGrey.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: (){
              setState(() {
                postOrientation = 'Grid';
              });
            },
            icon: Icon(
              Icons.grid_on,
              size: 20,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: (){
              setState(() {
                postOrientation = 'List';
              });
            },
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.list,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildProfileHeader(),
              Divider(
                height: 0,
                color: SpecialGrey.withOpacity(0.5),
              ),
              buildToggleProfileOrientation(),
              Divider(
                height: 0,
                color: SpecialGrey.withOpacity(0.5),
              ),
              SizedBox(
                height: 5,
              ),
              buildProfilePosts(),
            ],
          ),
        ],
      ),
    );
  }
}


class ProfileInfoCard extends StatelessWidget {
  final String text;
  final String count;
  const ProfileInfoCard({this.text, this.count});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextProfile,
          ),
          SizedBox(
            height: 3.0,
          ),
          Text(
            count,
            style: TextProfileCount,
          ),
        ],
      ),
    );
  }
}
