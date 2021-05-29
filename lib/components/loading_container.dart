import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingContainer extends StatelessWidget {
  const LoadingContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 40.0,
        ),
      ),
    );
  }
}
