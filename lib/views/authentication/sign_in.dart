import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/constants/loading.dart';
import 'package:shopping_cart/providers/authentication_notifiers.dart';
import 'package:shopping_cart/services/authentication_service.dart';
import 'package:shopping_cart/views/authentication/reset_password_dialog.dart';

class SignIn extends StatelessWidget {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final Function toggleFunction;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignIn({this.toggleFunction});

  @override
  Widget build(BuildContext buildContext) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoadingStateNotifier()),
        ChangeNotifierProvider(create: (_) => AttemptSuccessNotifier())
      ],
      builder: (providerContext, widget) {
        return Provider.of<LoadingStateNotifier>(providerContext).loadingNeeded ? Loading() : Scaffold(
          appBar: AppBar(
            elevation: 8,
            title: Text('Shopping Cart'),
            actions: [
              Consumer<SignInNotifier>(
                  builder: (_, signInNotifier, widget) {
                    return FlatButton.icon(
                      onPressed: () {
                        signInNotifier.toggle();
                      },
                      icon: Icon(Icons.person_add),
                      label: Text('Sign Up'),
                    );
                  })
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'E-mail',
                        hintText: 'example@gmail.com',
                      ),
                      validator: (val) {
                        String errorMsg;
                        if (val.isEmpty) errorMsg = 'Enter an e-mail';
                        return errorMsg;
                      },
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline_sharp),
                          labelText: 'Password'),
                      validator: (val) {
                        String errorMsg;
                        if (val.length < 6)
                          errorMsg = 'Minimum password length 6 characters';
                        return errorMsg;
                      },
                    ),
                    SizedBox(height: 5),
                    Consumer<AttemptSuccessNotifier> (
                      builder: (_, attemptSuccessNotifier, widget) {
                        return (attemptSuccessNotifier.unsuccessful)? Text(
                          'Signing in attempt unsuccessful! Try again',
                          style: TextStyle(
                            color: Colors.red
                          ),
                        ) : Container();
                      }
                    ),
                    SizedBox(height: 5),
                    RaisedButton(
                      color: Colors.blue[200],
                      splashColor: Colors.blue,
                      child: Text('Sign In'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          providerContext.read<LoadingStateNotifier>().set(true);
                          providerContext.read<AttemptSuccessNotifier>().set(false);
                          dynamic result = await _auth.signInWithEmailAndPassword(
                              emailController.text, passwordController.text);

                          if(result == null) {
                            providerContext.read<LoadingStateNotifier>().set(false);
                            providerContext.read<AttemptSuccessNotifier>().set(true);
                          }
                        }
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          color: Colors.blue
                        ),
                      ),
                      onPressed: () {
                        return showDialog<void>(
                            context: buildContext,
                            builder: (context) {
                              return ResetPasswordDialog();
                            }
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
