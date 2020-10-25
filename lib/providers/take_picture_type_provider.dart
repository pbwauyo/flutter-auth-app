import 'package:flutter/material.dart';

class TakePictureTypeProvider with ChangeNotifier{
  String _takePictureType = "";

  set takePictureType(String type){
    _takePictureType = type;
    notifyListeners();
  }

  String get takePictureType => _takePictureType;
}