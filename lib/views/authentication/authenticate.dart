import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/authentication_notifiers.dart';
import 'package:shopping_cart/views/authentication/sign_in.dart';
import 'package:shopping_cart/views/authentication/sign_up.dart';

typedef bool ToggleFunction(bool flag);

class Authenticate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (signInNotifierContext) => SignInNotifier(),
      builder: (signInNotifierContext, widget) {
        return signInNotifierContext.watch<SignInNotifier>().isSignIn ? SignIn() : SignUp();
      }
    );
  }
}
