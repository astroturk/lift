import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lift/tabs/chats_tab.dart';
import 'package:lift/tabs/create_workout_tab.dart';
import 'package:lift/tabs/posts_tab.dart';
import 'package:lift/tabs/profile_tab.dart';
import 'package:lift/tabs/start_workout_tab.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 4;
  PageController _pageController = PageController();
  List<Widget> _screens = [
    CreateWorkoutTab(),
    StartWorkoutTab(),
    PostsTab(),
    ChatsTab(),
    ProfileTab(),
  ];

  void _onPageChanged(int index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        color: Color(0xFF303030),
        backgroundColor: Colors.black,
        buttonBackgroundColor: Color(0xFF6531ff),
        height: 50.0,
        animationDuration: Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.add, size: 25, color: Colors.white,),
          Icon(Icons.timer, size: 25, color: Colors.white,),
          Icon(Icons.home, size: 25, color: Colors.white,),
          Icon(Icons.chat_bubble, size: 25, color: Colors.white,),
          Icon(Icons.account_circle, size: 25, color: Colors.white,),
        ],
        onTap: (index) {
          setState(() {
            _currentTab = index;
            _pageController.jumpToPage(_currentTab);
          });
        },
      ),
    );
  }
}
