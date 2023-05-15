import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/services/database_service.dart';
import 'package:shopping_cart/services/storage_service.dart';
import 'package:http/http.dart' as http;

class AuthService {

  static const String API_KEY = 'AIzaSyAwxy6LltVxUK0UOBllqs8bux7kYeRUDgw';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<Profile> get profile {
    return _auth.authStateChanges().map((user) {
      return (user != null) ? Profile(uid: user.uid) : null;
    });
  }


  Future signUpWithEmailAndPassword(File imageFile, String name, String phoneNumber, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      StorageTaskSnapshot snapShot = await ProfileImageStorage().uploadProfileImage(user.uid, imageFile);
      String imageUrl = await snapShot.ref.getDownloadURL();

      await ProfileDatabase(uid: user.uid).updateProfileData(imageUrl, name, phoneNumber, email);
      return (user != null ) ? Profile(uid: user.uid, imageUrl: imageUrl, name: name, phoneNumber: phoneNumber, email: email) : null;

    } catch(e) {
      print(e.toString());
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return (user != null ) ? Profile(uid: user.uid) : null;

    } catch(e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
    }
  }

  Future changePassword(String email, String currentPassword, String newPassword) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: currentPassword);
      await _auth.currentUser.updatePassword(newPassword);
      return 0;

    } catch (e) {
      print(e.toString());
      return 1;
    }
  }

  Future changeEmail(String passWord, String oldEmail, String newEmail) async {
    try {
      await _auth.signInWithEmailAndPassword(email: oldEmail, password: passWord);
      await _auth.currentUser.updateEmail(newEmail);
      return 0;

    } catch(e)
    {
      print(e.toString());
      return 1;
    }
  }

  Future deleteAccount(String passWord, String email) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: passWord);
      await _auth.currentUser.delete();
      return 0;

    } catch(e)
    {
      print(e.toString());
      return 1;
    }
  }

  Future authenticate(String passWord, String email) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: passWord);
      return 0;

    } catch(e)
    {
      print(e.toString());
      return 1;
    }
  }

  Future requestPasswordRequest(String email) async {
    final String resetPasswordUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$API_KEY';

    final Map<String, dynamic> payload = {
      'requestType': 'PASSWORD_RESET',
      'email' : email
    };

    http.Response response = await http.post(resetPasswordUrl, body: json.encode(payload), headers: {'Content-Type': 'application/json'});

    if(response.statusCode == 200) {
      return 0;
    } else {
      return 1;
    }
  }
}