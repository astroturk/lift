import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lift/screens/home_screen/home_screen_helpers.dart';
import 'package:provider/provider.dart';

class LoadingTab extends StatefulWidget {
  const LoadingTab({Key key}) : super(key: key);

  @override
  _LoadingTabState createState() => _LoadingTabState();
}

class _LoadingTabState extends State<LoadingTab> {
  Widget loadingCurrent(bool error){
    if (error) {
      return IconButton(
        icon: const Icon(Icons.refresh_rounded),
        iconSize: 40,
        onPressed: () {
          setState(() {
            Provider.of<HomeScreenHelpers>(context, listen: false).fetchProfileData(context);
          });
        },
      );
    }
    else {
      return SpinKitDoubleBounce(
        color: Colors.white,
        size: 40.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: loadingCurrent(Provider.of<HomeScreenHelpers>(context).profileDataFetchingError),
      ),
    );
  }
}
