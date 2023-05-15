import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/constants/updating.dart';
import 'package:shopping_cart/providers/authentication_notifiers.dart';
import 'package:shopping_cart/services/authentication_service.dart';

class ResetPasswordDialog extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();


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
                    Consumer<AttemptSuccessNotifier>(
                      builder: (_, attemptSuccessNotifier, widget) {
                        return (attemptSuccessNotifier.unsuccessful) ? Text(
                          'Password Resetting attempt unsuccessful! Try again',
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
            title: Text('Reset Password'),
            actions: [
              FlatButton(
                child: Text('Submit'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    providerContext.read<AttemptSuccessNotifier>().set(false);
                    providerContext.read<UpdatingProfileNotifier>().set(true);
                    int result = await AuthService().requestPasswordRequest(emailController.text);
                    if (result == 0) {
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
