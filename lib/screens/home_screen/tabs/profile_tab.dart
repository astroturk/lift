import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lift/components/custom_alert_dialog_box.dart';
import 'package:lift/components/navigation_button.dart';
import 'package:lift/components/post_tile.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/model/post.dart';
import 'package:lift/screens/edit_profile/edit_profile.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';
import 'package:lift/screens/home_screen/tabs/loading_tab.dart';
import 'package:provider/provider.dart';
import 'package:lift/services/authentication.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Widget bodyCurrent(bool dataFetched){
    if(dataFetched) return ProfileBody();
    else return LoadingTab();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'LIFT',
          style: TextTitleWhiteSmall,
        ),
        leading: IconButton(
          icon: Icon(Icons.settings),
          iconSize: 25,
          onPressed: () {},
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              iconSize: 25,
              onPressed: () async{
                try {
                  await Provider.of<Authentication>(context, listen: false)
                      .logOutAccount(context);
                } catch(error){
                  showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialogBox(
                        context: context,
                        title: 'Error',
                        message: 'Could Not Log Out User',
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK', style: TextMediumGreen, ),
                          ),
                        ],
                      )
                  );
                }
              },
          ),
        ],
      ),
      body: bodyCurrent(Provider.of<HomeScreenHelpers>(context).profileDataFetched),
    );
  }
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({Key key}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool isLoading = false;
  int workoutCount = 0;
  List<Post> posts = [];
  String postOrientation = "Grid";

  @override
  void initState() {
    super.initState();
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });

    print(Provider.of<Authentication>(context, listen: false).getUserUid);
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('workouts')
      .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
      .collection('userWorkouts')
      .get();

    setState(() {
      isLoading = false;
      workoutCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc.data())).toList();
    });
    print(workoutCount);
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
              Container(
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
                            backgroundImage: NetworkImage(Provider.of<HomeScreenHelpers>(context).getImage),
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
                                    count: '0',
                                  ),
                                  ProfileInfoCard(
                                    text: 'Followers',
                                    count: '0',
                                  ),
                                ],
                              ),
                              NavigationButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                                },
                                text: 'Edit Profile',
                              ),
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
                            Provider.of<HomeScreenHelpers>(context).getUserName,
                            style: TextProfile.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            Provider.of<HomeScreenHelpers>(context).getFullName,
                            style: TextProfile.copyWith(fontWeight: FontWeight.w100),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            Provider.of<HomeScreenHelpers>(context).bio == null ? '' : Provider.of<HomeScreenHelpers>(context).bio,
                            style: TextProfile,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
