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
  var emojiTopPosition = 20.0.obs;
  var emojiLeftPosition = 20.0.obs;
  var selectedEmoji = "".obs;
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

  resetEmojiPosition(){
    emojiTopPosition.value = 20.0;
    emojiLeftPosition.value = 20.0;
  }

  resetEmoji(){
    selectedEmoji.value = "";
  }

  setColorFilter(int newValue){
    selectedColorFilter.value = newValue;
  }
}