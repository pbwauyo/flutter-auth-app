import 'package:flutter/material.dart';

class MomentIdProvider with ChangeNotifier{
  String _momentId = "";

  set momentid(String type){
    _momentId = type;
    notifyListeners();
  }

  String get momentid => _momentId;
}