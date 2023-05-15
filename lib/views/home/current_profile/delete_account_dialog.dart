import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/constants/updating.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/providers/authentication_notifiers.dart';
import 'package:shopping_cart/services/authentication_service.dart';
import 'package:shopping_cart/services/database_service.dart';
import 'package:shopping_cart/services/storage_service.dart';

class DeleteAccountDialog extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final Profile profile;
  final Function callBack;

  DeleteAccountDialog({this.profile, this.callBack});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


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
                      controller: emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'E-mail',
                      ),
                      validator: (val) {
                        String errorMsg;
                        if (val.isEmpty) errorMsg = "Field can't be empty";
                        return errorMsg;
                      },
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock_outline_sharp),
                        labelText: 'Current Password',
                      ),
                      validator: (val) {
                        String errorMsg;
                        if (val.isEmpty)
                          errorMsg = "Field can't be empty";
                        else if(val.length < 6)
                          errorMsg = 'Too short';
                        return errorMsg;
                      },
                    ),
                    SizedBox(height: 5),
                    Consumer<AttemptSuccessNotifier>(
                      builder: (_, attemptSuccessNotifier, widget) {
                        return (attemptSuccessNotifier.unsuccessful) ? Text(
                          'Deleting attempt unsuccessful! Try again',
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
            title: Text('Authenticate account'),
            actions: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  callBack(false);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  'Delete',
                  style: TextStyle(
                      color: Colors.red
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    providerContext.read<AttemptSuccessNotifier>().set(false);
                    providerContext.read<UpdatingProfileNotifier>().set(true);

                    int authResult = await AuthService().authenticate(passwordController.text, emailController.text);

                    if(authResult == 0) {
                      FavouriteDatabase().deleteFavouritePairByProfileId(profile.uid);
                      ProductDatabase().deleteProductsByOwnerId(profile.uid);
                      await ProfileDatabase(uid: profile.uid).deleteUserData();
                      await ProfileImageStorage().deleteProfileImage(profile.uid);
                      int deleteResult = await AuthService().deleteAccount(passwordController.text, emailController.text);

                      if(deleteResult == 0) {
                        callBack(true);
                        Navigator.pop(context);
                      }
                    } else {
                      providerContext.read<UpdatingProfileNotifier>().set(false);
                      providerContext.read<AttemptSuccessNotifier>().set(true);
                    }
                  }
                },
              ),
            ],
          );
        }
    );
  }
}
