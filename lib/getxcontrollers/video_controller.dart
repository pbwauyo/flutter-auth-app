import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  var percentage = 0.0.obs;
  var videoText = "".obs;
  var textColor = Colors.white.obs;
  var isRecording = false.obs;
  var recordedSeconds = 0.obs;
  var isFiltering = false.obs;
  var videoPath = "".obs;
}