import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_cart/constants/avatar.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../image_viewer_dialog.dart';

class SellerProfileViewer extends StatelessWidget {
  final Profile profile;

  SellerProfileViewer({this.profile});

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber[600],
              ),
              child: GestureDetector(
                child: Avatar(
                  imageProvider: NetworkImage(profile.imageUrl),
                  radius: 50,
                ),
                onTap: () {
                  showDialog<void>(
                      context: buildContext,
                      child: ImageViewerDialog(imgUrl: profile.imageUrl)
                  );
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${profile.name}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Colors.green[600],
                    ),
                    onPressed: () async {
                      bool result = await launch("tel://${profile.phoneNumber}");

                      if(result == false) showToast("Calling attempt unsuccessful!");
                    }),
                Text('${profile.phoneNumber}')
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.message,
                      color: Colors.green[600],
                    ),
                    onPressed: () async {
                      bool result = await launch("sms://${profile.phoneNumber}");

                      if(result == false) showToast("Sending SMS attempt unsuccessful!");
                    }),
                Text('${profile.phoneNumber}')
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.email,
                      color: Colors.green[600],
                    ),
                    onPressed: () async {
                      bool result = await launch("mailto://${profile.email}");

                      if(result == false) showToast("Mailing attempt unsuccessful!");
                    }),
                Text('${profile.email}')
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.payment,
                      color: Colors.grey,
                    ),
                    splashColor: Colors.transparent,
                    tooltip: 'Not developed yet',
                    onPressed: () {
                    }),
                Text('Transaction Procedure', style: TextStyle(color: Colors.grey))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
