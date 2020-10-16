import 'package:flutter/material.dart';

class FilePathProvider with ChangeNotifier{
  String _filePath = "";

  set filePath(String filePath){
    _filePath = filePath;
    notifyListeners();
  }

  String get filePath => _filePath;

}