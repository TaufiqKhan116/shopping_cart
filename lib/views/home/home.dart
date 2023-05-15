import 'package:flutter/material.dart';
import 'package:shopping_cart/constants/updating.dart';
import 'package:shopping_cart/services/authentication_service.dart';
import 'package:shopping_cart/services/database_service.dart';
import 'package:shopping_cart/views/home/all_products/all_products_viewer.dart';
import 'file:///G:/Programming/Android/Flutter/shopping_cart/lib/views/home/current_profile/profile_viewer.dart';
import 'package:shopping_cart/views/home/user_products/user_products_list.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  final String uid;

  Home({this.uid});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 8,
          title: Text('Shopping Cart'),
          actions: [
            FlatButton.icon(
              onPressed: () {
                _auth.signOut();
              },
              icon: Icon(Icons.power_settings_new_sharp),
              label: Text('Log out'),
            ),
          ],
        ),
        bottomNavigationBar: Material(
          color: Theme.of(context).colorScheme.primary,
          child: TabBar(
            indicatorColor: Colors.amber,
            tabs: [
              Tab(
                icon: Icon(Icons.widgets_sharp),
                text: 'Products',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket_sharp),
                text: 'My Products',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Profile',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
                stream: ProfileDatabase(uid: uid).userData,
                builder: (streamContext, snapshot) {
                  if (snapshot.hasData)
                    return AllProductViewer(currentProfile: snapshot.data);
                  else
                    return Updating();
                }),
          StreamBuilder(
              stream: ProfileDatabase(uid: uid).userData,
              builder: (streamContext, snapshot) {
                if (snapshot.hasData)
                  return UserProductList(profile: snapshot.data);
                else
                  return Updating();
              }),
            StreamBuilder(
                stream: ProfileDatabase(uid: uid).userData,
                builder: (streamContext, snapshot) {
                  if (snapshot.hasData)
                    return ProfileViewer(profile: snapshot.data);
                  else
                    return Updating();
                }),
          ],
        ),
      ),
    );
  }
}
