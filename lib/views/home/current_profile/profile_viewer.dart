import 'package:flutter/material.dart';
import 'package:shopping_cart/constants/avatar.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/views/home/current_profile/profile_editor.dart';

import '../../image_viewer_dialog.dart';


class ProfileViewer extends StatelessWidget {
  final Profile profile;

  ProfileViewer({this.profile});

  @override
  Widget build(BuildContext buildContext) {

    return Padding(
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
                  onPressed: () {}),
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
                  onPressed: () {}),
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
                  onPressed: () {
                    print(profile.email);
                  }),
              Text('${profile.email}')
            ],
          ),
          Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black38,
                  ),
                  onPressed: () async {
                    Navigator.push(buildContext, MaterialPageRoute(
                      builder: (context) {
                        return ProfileEditor(profile: profile);
                      }
                    ));
                  }),
              Text('Edit Profile')
            ],
          )
        ],
      ),
    );
  }
}
