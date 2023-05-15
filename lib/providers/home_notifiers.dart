import 'package:flutter/cupertino.dart';

class FabIconChangeNotifier with ChangeNotifier {
  bool _addIcon = false;

  void set(bool flag) {
    _addIcon = flag;
    notifyListeners();
  }

  bool get addIcon {
    return _addIcon;
  }
}

class CategoryChangeNotifier with ChangeNotifier {
  String _category;

  void set(String category) {
    _category = category;
    notifyListeners();
  }

  String get category {
    return _category ?? 'All';
  }
}

class SearchParameterChangeNotifier with ChangeNotifier {
  String _searchParam;

  void set(String searchParam) {
    _searchParam = searchParam;
    notifyListeners();
  }

  String get searchParam {
    return _searchParam ?? '';
  }
}