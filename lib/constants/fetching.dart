import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Fetching extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitSpinningCircle(
          color: Colors.blue[100],
          size: 30.0,
        ),
      ),
    );
  }
}
