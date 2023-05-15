import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/constants/updating.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/providers/authentication_notifiers.dart';
import 'package:shopping_cart/services/authentication_service.dart';
import 'package:shopping_cart/services/database_service.dart';
import 'package:shopping_cart/services/storage_service.dart';
import 'file:///G:/Programming/Android/Flutter/shopping_cart/lib/views/home/current_profile/change_email_dialog.dart';
import 'file:///G:/Programming/Android/Flutter/shopping_cart/lib/views/home/current_profile/change_password_dialog.dart';
import 'file:///G:/Programming/Android/Flutter/shopping_cart/lib/views/home/current_profile/delete_account_dialog.dart';

class ProfileEditor extends StatelessWidget {

  final Profile profile;

  ProfileEditor({this.profile});

  final _formKey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void setControllers() {
    nameController.text = profile.name;
    phoneNumberController.text = profile.phoneNumber;
  }

  Future getImage(ImageSource imageSource) async {
    final pickerFile = await imagePicker.getImage(source: imageSource);
    if (pickerFile != null) {
      return File(pickerFile.path);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImageFileNotifier()),
          ChangeNotifierProvider(create: (_) => LoadingStateNotifier()),
          ChangeNotifierProvider(create: (_) => UpdatingProfileNotifier()),
          ChangeNotifierProvider(create: (_) => AuthStateChangedNotifier())
        ],
        builder: (providerContext, widget) {
          setControllers();

          return (providerContext.watch<UpdatingProfileNotifier>().updating) ? Updating() : Scaffold(
            appBar: AppBar(
              elevation: 8,
              title: Text('Edit Profile'),
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
                          if(providerContext.read<AuthStateChangedNotifier>().signOut) {
                            Navigator.pop(buildContext);
                            return null;
                          }

                          return showDialog<void>(
                              context: buildContext,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Upload Image from'),
                                  actions: [
                                    FlatButton(
                                      child: Text('Camera'),
                                      onPressed: () async {
                                        File imageFile = await getImage(ImageSource.camera);
                                        providerContext.read<ImageFileNotifier>().changeImageFile(imageFile);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Gallery'),
                                      onPressed: () async {
                                        File imageFile = await getImage(ImageSource.gallery);
                                        providerContext.read<ImageFileNotifier>().changeImageFile(imageFile);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
                          padding: EdgeInsets.all(3),
                          child: Consumer<ImageFileNotifier>(
                              builder: (_, imageChangeNotifier, widget) {
                                File imageFile = imageChangeNotifier.imageFile;
                                return CircleAvatar(
                                  radius: 45,
                                  backgroundImage: (imageFile != null) ? FileImage(imageFile) : NetworkImage(profile.imageUrl),
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
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black38,
                              ),
                              onPressed: () {
                                if(providerContext.read<AuthStateChangedNotifier>().signOut) {
                                  Navigator.pop(buildContext);
                                  return null;
                                }

                                return showDialog<void>(
                                  context: buildContext,
                                  builder: (context) {
                                    return ChangeEmailDialog(profile: profile);
                                  }
                                );
                              }),
                          Text('Edit e-mail address')
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black38,
                              ),
                              onPressed: () {
                                if(providerContext.read<AuthStateChangedNotifier>().signOut) {
                                  Navigator.pop(buildContext);
                                  return null;
                                }

                                return showDialog<void>(
                                    context: buildContext,
                                    builder: (context) {
                                      return ChangePasswordDialog(profile: profile);
                                    }
                                );
                              }),
                          Text('New password')
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                if(providerContext.read<AuthStateChangedNotifier>().signOut) {
                                  Navigator.pop(buildContext);
                                  return null;
                                }

                                return showDialog<void>(
                                    context: buildContext,
                                    builder: (context) {
                                      return DeleteAccountDialog(profile: profile, callBack: (flag) {
                                        providerContext.read<AuthStateChangedNotifier>().set(flag ?? false);
                                      });
                                    }
                                );
                              }),
                          Text(
                            'Delete Account',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Consumer<ImageFileNotifier>(
                          builder: (_, imageFileNotifier, widget) {
                            return RaisedButton(
                              color: Colors.blue[200],
                              splashColor: Colors.blue,
                              child: Text('Update'),
                              onPressed: () async {
                                if(providerContext.read<AuthStateChangedNotifier>().signOut) {
                                  Navigator.pop(buildContext);
                                  return;
                                }

                                String imageUrl = profile.imageUrl;

                                if(imageFileNotifier.imageFile != null) {
                                  await ProfileImageStorage().deleteProfileImage(profile.uid);
                                  StorageTaskSnapshot snapshot = await ProfileImageStorage().uploadProfileImage(profile.uid, imageFileNotifier.imageFile);
                                  imageUrl = await snapshot.ref.getDownloadURL();
                                }
                                if (_formKey.currentState.validate()) {
                                  providerContext.read<UpdatingProfileNotifier>().set(true);

                                  dynamic result = await ProfileDatabase(uid: profile.uid).updateProfileData(imageUrl, nameController.text, phoneNumberController.text, profile.email);
                                  Navigator.pop(buildContext);
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
        });
  }
}