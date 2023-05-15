import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/constants/loading.dart';
import 'package:shopping_cart/providers/authentication_notifiers.dart';
import 'package:shopping_cart/services/authentication_service.dart';
import 'package:shopping_cart/services/storage_service.dart';

class SignUp extends StatelessWidget {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future getImage(ImageSource imageSource) async {
    final pickerFile = await imagePicker.getImage(source: imageSource);
    if (pickerFile != null) {
      return File(pickerFile.path);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImageFileNotifier()),
          ChangeNotifierProvider(create: (_) => LoadingStateNotifier())
        ],
        builder: (providerContext, widget) {
          return Provider
              .of<LoadingStateNotifier>(providerContext)
              .loadingNeeded ? Loading() : Scaffold(
            appBar: AppBar(
              elevation: 8,
              title: Text('Shopping Cart'),
              actions: [
                Consumer<SignInNotifier>(builder: (_, signInNotifier, widget) {
                  return FlatButton.icon(
                    onPressed: () {
                      signInNotifier.toggle();
                    },
                    icon: Icon(Icons.lock_open_sharp),
                    label: Text('Sign In'),
                  );
                })
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          return showDialog<void>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Upload Image from'),
                                  actions: [
                                    FlatButton(
                                      child: Text('Camera'),
                                      onPressed: () async {
                                        File imageFile = await getImage(
                                            ImageSource.camera);
                                        providerContext.read<
                                            ImageFileNotifier>()
                                            .changeImageFile(imageFile);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Gallery'),
                                      onPressed: () async {
                                        File imageFile = await getImage(
                                            ImageSource.gallery);
                                        providerContext.read<
                                            ImageFileNotifier>()
                                            .changeImageFile(imageFile);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle,
                              color: Colors.amber),
                          padding: EdgeInsets.all(3),
                          child: Consumer<ImageFileNotifier>(
                              builder: (_, imageChangeNotifier, widget) {
                                File imageFile = imageChangeNotifier.imageFile;
                                return CircleAvatar(
                                  radius: 45,
                                  backgroundImage: (imageFile != null)
                                      ? FileImage(imageFile)
                                      : AssetImage(
                                      'assets/images/empty_profile_pic.png'),
                                );
                              }),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Name',
                          hintText: 'Example Name',
                        ),
                        validator: (val) {
                          String errorMsg;
                          if (val.isEmpty) errorMsg = 'Enter your name';
                          return errorMsg;
                        },
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.phone),
                          labelText: 'Phone Number',
                          prefixText: '+88',
                        ),
                        validator: (val) {
                          String errorMsg;
                          if (val.isEmpty)
                            errorMsg = 'Enter your contact number';
                          if (val.length < 11)
                            errorMsg = 'Invalid contact number';
                          return errorMsg;
                        },
                      ),
                      SizedBox(height: 5),
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
                      Consumer<ImageFileNotifier>(
                          builder: (_, imageFileNotifier, widget) {
                            return RaisedButton(
                              color: Colors.blue[200],
                              splashColor: Colors.blue,
                              child: Text('Sign Up'),
                              onPressed: () async {
                                if (imageFileNotifier.imageFile == null) {
                                  return showDialog(
                                      context: context,
                                      builder: (simpleDialogContext) {
                                        return SimpleDialog(
                                          title: Text('Please upload an image'),
                                          children: [
                                            FlatButton(
                                              child: Text('Ok'),
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      simpleDialogContext),
                                            )
                                          ],
                                        );
                                      }
                                  );
                                }
                                if (_formKey.currentState.validate()) {
                                  providerContext.read<LoadingStateNotifier>()
                                      .set(true);
                                  dynamic result = await _auth
                                      .signUpWithEmailAndPassword(
                                      imageFileNotifier.imageFile,
                                      nameController.text,
                                      phoneNumberController.text,
                                      emailController.text,
                                      passwordController.text);

                                  if (result == null) {
                                    providerContext.read<LoadingStateNotifier>()
                                        .set(false);
                                  }
                                }
                              },
                            );
                          }
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
