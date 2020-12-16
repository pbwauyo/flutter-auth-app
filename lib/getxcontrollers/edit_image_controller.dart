import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditImageController extends GetxController {
  var text = "".obs;
  var textColor = Colors.white.obs;
  var selectedColorFilter = 11.obs;
  var hasFocus = true.obs;
  var paintPoints = <Offset>[].obs;
  var shouldPaint = false.obs;
  var paintColor = Colors.white.obs;
  // var backgroundColorIndex = 0.obs;

  updatePainPointsList(Offset offset){
    paintPoints.add(offset);
  }

  clearPaintPointsList(){
    paintPoints.clear();
  }

  toggleShouldPaint(){
    shouldPaint.value = !shouldPaint.value;
  }

  resetShouldPaint(){
    shouldPaint.value = false;
  }

  resetImageText(){
    text.value = "";
  }

  setColorFilter(int newValue){
    selectedColorFilter.value = newValue;
  }
}