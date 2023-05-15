import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/views/authentication/authenticate.dart';

import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);
    return (profile == null) ? Authenticate() : Home(uid: profile.uid);
  }
}