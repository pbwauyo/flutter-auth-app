import 'dart:convert';
import 'dart:io';

import 'package:auth_app/pages/preview_recorded_video.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;

import 'package:path_provider/path_provider.dart';


class Methods {

  static showGeneralErrorToast(dynamic error){
    Fluttertoast.showToast(
      msg: error.message,
      textColor: AppColors.ERROR_COLOR,
      toastLength: Toast.LENGTH_LONG
    );
  }

  static showFirebaseErrorToast(dynamic error){
    Fluttertoast.showToast(
      msg: error,
      textColor: AppColors.ERROR_COLOR,
      toastLength: Toast.LENGTH_LONG
    );
  }

  static showCustomToast(dynamic error){
    Fluttertoast.showToast(
      msg: error,
      textColor: Colors.white,
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_SHORT
    );
  }

  static String generateOauthNonce(){
    math.Random rnd = new math.Random();

    List<int> values = new List<int>.generate(32, (i) => rnd.nextInt(256));
     return base64UrlEncode(values).replaceAll(new RegExp('[=/+]'), '');
  }

  static showCustomSnackbar({@required BuildContext context, 
  @required String message, String actionLabel="", VoidCallback actionOnTap}){
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: actionLabel.isNotEmpty ? Duration(days: 2) : Duration(milliseconds: 4000),
        content: Text(message),
        action: SnackBarAction(
          label: actionLabel, 
          onPressed: actionOnTap ?? (){}
        ),
      )
    );
  }

  static Future<String> getVideoPath() async{
    String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/happr';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';
    return filePath;
  }

  static Future<String> startVideoRecording(CameraController cameraController, String filePath) async{
    
    if (!cameraController.value.isInitialized) {
      return null;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await cameraController.startVideoRecording(filePath);
    } on CameraException catch (e) {
      return null;
    }
    return filePath;
  }

  static Future<void> stopVideoRecording(CameraController cameraController) async{
    if (!cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      return null;
    }
  }

  static playVideo({@required BuildContext context, @required String videoPath}){
    Navigations.goToScreen(context, PreviewRecordedVideo(path: videoPath));
  }

}