import 'dart:io';
import 'package:flutter/cupertino.dart';

class SignInNotifier with ChangeNotifier {
  bool _isSignIn = true;

  void toggle() {
    _isSignIn = !_isSignIn;
    notifyListeners();
  }

  bool get isSignIn {
    return _isSignIn;
  }
}

class ImageFileNotifier with ChangeNotifier {
  File _imageFile;

  void changeImageFile(File imageFile) {
    this._imageFile = imageFile;
    notifyListeners();
  }

  File get imageFile {
    if(_imageFile != null) return _imageFile;
    else return null;
  }
}

class LoadingStateNotifier with ChangeNotifier {
  bool _loadingNeeded = false;

  void set(bool flag) {
    _loadingNeeded = flag;
    notifyListeners();
  }

  bool get loadingNeeded {
    return _loadingNeeded;
  }
}

class UpdatingProfileNotifier with ChangeNotifier {
  bool _updating = false;

  void set(bool flag) {
    _updating = flag;
    notifyListeners();
  }

  bool get updating {
    return _updating;
  }
}

class AttemptSuccessNotifier with ChangeNotifier {
  bool _unsuccessful = false;

  void set(bool flag) {
    _unsuccessful = flag;
    notifyListeners();
  }

  bool get unsuccessful {
    return _unsuccessful;
  }
}

class AuthStateChangedNotifier with ChangeNotifier {
  bool _signOut = false;

  void set(bool flag) {
    _signOut = flag;
    notifyListeners();
  }

  bool get signOut {
    return _signOut;
  }
}