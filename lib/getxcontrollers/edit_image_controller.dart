import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditImageController extends GetxController {
  var text = "".obs;
  var textColor = Colors.white.obs;
  var selectedColorFilter = 11.obs;
  var hasFocus = true.obs;
  // var backgroundColorIndex = 0.obs;

  resetImageText(){
    text.value = "";
  }

  setColorFilter(int newValue){
    selectedColorFilter.value = newValue;
  }
}