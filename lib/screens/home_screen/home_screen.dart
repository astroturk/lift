import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lift/constants/constants.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';
import 'package:lift/screens/home_screen/tabs/activity_feed_tab.dart';
import 'package:lift/screens/home_screen/tabs/search_tab.dart';
import 'package:lift/screens/home_screen/tabs/create_workout_tab.dart';
import 'package:lift/screens/home_screen/tabs/posts_tab.dart';
import 'package:lift/screens/home_screen/tabs/profile_tab.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:lift/services/workouts.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AfterLayoutMixin<HomeScreen> {

  int _currentTab = 0;
  PageController _pageController = PageController();
  List<Widget> _screens = [
    CreateWorkoutTab(),
    ActivityFeedTab(),
    PostsTab(),
    SearchTab(),
    ProfileTab(),
  ];
  void _onPageChanged(int index) {}

  @override
  void afterFirstLayout(BuildContext context) {
    Provider.of<HomeScreenHelpers>(context, listen: false).fetchProfileData(context);
    Provider.of<Workouts>(context, listen: false).createNewWorkout(context);
  }

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
        color: Color(0xFF303030),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: SpecialPurple,
        height: 50.0,
        animationDuration: Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.add, size: 25, color: Colors.white,),
          Icon(Icons.notifications_active, size: 25, color: Colors.white,),
          Icon(Icons.home, size: 25, color: Colors.white,),
          Icon(Icons.search, size: 25, color: Colors.white,),
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
