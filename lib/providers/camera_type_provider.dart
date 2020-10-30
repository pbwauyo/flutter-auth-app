import 'package:flutter/material.dart';

class CameraTypeProvider with ChangeNotifier {
  int _camera = 0;

  set camera(int filePath){
    _camera = filePath;
    notifyListeners();
  }

  int get camera => _camera;

}