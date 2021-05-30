import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lift/components/form_input.dart';
import 'package:lift/components/loading_container.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/profile_screen/profile_screen.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String searchQuery = '';
  Future <QuerySnapshot> searchResultsFuture;

  handleSearch(String query){
    try {
      Future<QuerySnapshot> users = FirebaseFirestore.instance.collection('users')
          .where('user_full_name', isGreaterThanOrEqualTo: query).get();
      setState(() {
        searchResultsFuture = users;
      });
    } catch (error) {
      print('error');
    }
  }

  buildSearchResults(){
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        else {
          List<Widget> searchResults = [];
          snapshot.data.docs.forEach((doc){
            searchResults.add(
              UserSearchCard(
                userName: doc['user_name'],
                fullName: doc['user_full_name'],
                imageUrl: doc['user_image'],
                userId: doc['user_uid'],
              ));
          });
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ListView(
              children: searchResults,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.account_box,
            size: 30,
          ),
          onPressed: (){},
        ),
        title: FormInput(
          onChange: (value){
            setState(() {
              searchQuery = value;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 25,
            ),
            onPressed: (){
              handleSearch(searchQuery);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: searchResultsFuture == null ? Container(color: Colors.black,) : buildSearchResults(),
    );
  }
}

class UserSearchCard extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String fullName;
  final String userId;
  UserSearchCard({this.imageUrl, this.userName, this.fullName, this.userId});

  showProfile(BuildContext context){
    print(userId);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(userId: userId,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showProfile(context);
      },
      child: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor: Colors.white,
              radius: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: TextButtonWhite.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  fullName,
                  style: TextButtonWhite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


