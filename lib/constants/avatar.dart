import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final ImageProvider imageProvider;
  final double radius;

  Avatar({this.imageProvider, this.radius});

  @override
  Widget build(BuildContext context) {

    return CircleAvatar(
      backgroundImage: imageProvider,
      backgroundColor: Colors.transparent,
      radius: radius,
    );
  }
}
