import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileImageStorage {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future uploadProfileImage(String fileName, File imageFile) async {

    return await firebaseStorage.ref().child('profileimages').child(fileName).putFile(imageFile).onComplete;
  }

  Future deleteProfileImage(String fileName) async {
    return await firebaseStorage.ref().child('profileimages').child(fileName).delete();
  }
}

class ProductImageStorage {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future uploadProductImage(String fileName, File imageFile) async {

    return await firebaseStorage.ref().child('productimages').child(fileName).putFile(imageFile).onComplete;
  }

  Future deleteProductImage(String fileName) async {
    return await firebaseStorage.ref().child('productimages').child(fileName).delete();
  }
}