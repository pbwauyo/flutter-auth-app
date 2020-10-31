import 'package:flutter/material.dart';

class MomentTypeProvider with ChangeNotifier {
  String _momentType = "";

  String get momentType => _momentType;

  set momentType (String newMomentType){
    _momentType = newMomentType;
    notifyListeners();
  }
}