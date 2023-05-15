import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shopping_cart/constants/fetching.dart';

class ImageViewerDialog extends StatelessWidget {
  final String imgUrl;

  ImageViewerDialog({this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoView(imageProvider: NetworkImage(imgUrl)),
        Positioned(
          top: 5,
          left: 0,
          child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_rounded, color: Colors.grey, size: 30)
          ),
        )
      ],
    );
  }
}