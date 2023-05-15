import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/constants/updating.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/providers/authentication_notifiers.dart';
import 'package:shopping_cart/services/authentication_service.dart';
import 'package:shopping_cart/services/database_service.dart';

class ChangeEmailDialog extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final Profile profile;

  ChangeEmailDialog({this.profile});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController oldEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (buildContext) => UpdatingProfileNotifier()),
        ChangeNotifierProvider(create: (buildContext) => AttemptSuccessNotifier()),
      ],
      builder: (providerContext, widget) {
        return (providerContext.watch<UpdatingProfileNotifier>().updating) ? Updating() : AlertDialog(
          backgroundColor: Colors.amber[50],
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock_outline_sharp),
                      labelText: 'Current password',
                    ),
                    validator: (val) {
                      String errorMsg;
                      if (val.isEmpty) errorMsg = "Field can't be empty";
                      return errorMsg;
                    },
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: oldEmailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Old E-mail address',
                      hintText: 'example@gmail.com',
                    ),
                    validator: (val) {
                      String errorMsg;
                      if (val.isEmpty)
                        errorMsg = "Field can't be empty";
                      return errorMsg;
                    },
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: newEmailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'New E-mail address',
                      hintText: 'example@gmail.com',
                    ),
                    validator: (val) {
                      String errorMsg;
                      if (val.isEmpty)
                        errorMsg = "Field can't be empty";
                      return errorMsg;
                    },
                  ),
                  SizedBox(height: 5),
                  Consumer<AttemptSuccessNotifier>(
                    builder: (_, attemptSuccessNotifier, widget) {
                      return (attemptSuccessNotifier.unsuccessful) ? Text(
                        'Updating attempt unsuccessful! Try again',
                        style: TextStyle(
                          color: Colors.red
                        ),
                      ) : Container();
                    },
                  )
                ],
              ),
            ),
          ),
          title: Text('Change E-mail Address'),
          actions: [
            FlatButton(
              child: Text('Submit'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  providerContext.read<AttemptSuccessNotifier>().set(false);
                  providerContext.read<UpdatingProfileNotifier>().set(true);
                  int result = await AuthService().changeEmail(
                      passwordController.text, oldEmailController.text,
                      newEmailController.text);
                  if (result == 0) {
                    ProfileDatabase(uid: profile.uid).updateProfileData(
                        profile.imageUrl, profile.name, profile.phoneNumber,
                        newEmailController.text);
                    Navigator.pop(context);
                  } else {
                    providerContext.read<UpdatingProfileNotifier>().set(false);
                    providerContext.read<AttemptSuccessNotifier>().set(true);
                  }
                }
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }
}
