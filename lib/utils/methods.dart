import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auth_app/getxcontrollers/video_controller.dart';
import 'package:auth_app/pages/preview_recorded_video.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'dart:math' as math;
import 'package:path/path.dart' show basename, join;

import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


class Methods {

  static showGeneralErrorToast(dynamic error){
    Fluttertoast.showToast(
      msg: error,
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

  static showCustomToast(dynamic message){
    Fluttertoast.showToast(
      msg: message,
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

  static playVideo({@required BuildContext context}){
    Navigations.goToScreen(context, PreviewRecordedVideo());
  }

  static encodeTextToVideoCommand({@required String videoPath, String outputPath, @required String text, String fontSize = "35", String fontColor="white", String top, String left}){
    final command = "-i $videoPath -vf drawtext=\"fontfile=OpenSans-Light.ttf: text=\'$text\': fontcolor=$fontColor: fontsize=$fontSize: box=1: boxcolor=black@0.5: boxborderw=5: x=$left: y=$top\" -codec:a copy $outputPath";
    return command;
  }

  static String scaleVideoCommand({@required String videoPath, String outputPath, @required String width, @required String height }){
    final command = "-i $videoPath -vf scale=-1:$height $outputPath";
    return command;
  }

  static convertToPercent(double value, double max, {double percentage}){
    final result = (value / max) * percentage;
    return result.toInt();
  }

  static String colorToHexString(Color color){
    final hexString = "${color.value.toRadixString(16).padLeft(6, '0')}";
    final firstPart = hexString.substring(0,2);
    final lastPart = hexString.substring(2);
    return "#$lastPart$firstPart";
  }

  static Future<ImageProvider> generateImageProvider({@required String mediaPath}) async{
    if(mediaPath.endsWith(".mp4")){
      if(mediaPath.startsWith("http")){
        final networkThumbnailPath = await VideoThumbnail.thumbnailFile(
          video: mediaPath,
          thumbnailPath: (await getTemporaryDirectory()).path,
          quality: 75,
          maxHeight: 160
        );
        return NetworkImage(networkThumbnailPath);
      }else{
        final memoryThumbnailPath = await VideoThumbnail.thumbnailFile(
          video: mediaPath,
          quality: 75,
          maxHeight: 160
        );
        final file = File(memoryThumbnailPath);
        return FileImage(file);
      }
    }else{
      if(mediaPath.startsWith("http")){
        return NetworkImage(mediaPath);
      }else{
        return FileImage(File(mediaPath));
      }
    }
  }

  static Future<ImageProvider> generateNetworkImageProvider({@required String mediaUrl, String category}) async{
    if(mediaUrl.isEmpty){
      return AssetImage(Constants.momentImages[category]);
    }
    else if(mediaUrl.contains(".mp4")){
      final networkThumbnailPath = await VideoThumbnail.thumbnailFile(
        video: mediaUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        quality: 75,
        maxHeight: 160
      );
      return FileImage(File(networkThumbnailPath));
    }else{
      return NetworkImage(mediaUrl);
    }
  }

  static bool isVideo(String path){
    print("IS VIDEO PATH: $path");
    return path.isNotEmpty && path.contains(".mp4");
  }

  static Future<File> fileFromAsset(String assetPath) async{
    final tempDir = await getTemporaryDirectory();
    final assetDirPath = "${tempDir.path}/happr_assets";
    await Directory(assetDirPath).create(recursive: true);
    final byteData = await rootBundle.load(assetPath);
    final buffer = byteData.buffer;
    final generatedFile = await File("$assetDirPath/${basename(assetPath)}").writeAsBytes(
      buffer.asInt8List(byteData.offsetInBytes, byteData.lengthInBytes)
    );
    return generatedFile;
  }

  static Future<Uint8List> int8ListFromAsset(String assetPath) async{
    final tempDir = await getTemporaryDirectory();
    final assetDirPath = "${tempDir.path}/happr_assets";
    await Directory(assetDirPath).create(recursive: true);
    final byteData = await rootBundle.load(assetPath);
    final buffer = byteData.buffer;
    print("PREVIEW_SCREEN ASSET PATH: $assetDirPath/${basename(assetPath)}");
    final generatedFile = await File("$assetDirPath/${basename(assetPath)}").writeAsBytes(
      buffer.asInt8List(byteData.offsetInBytes, byteData.lengthInBytes)
    );
    return generatedFile.readAsBytesSync();
  }

  // static String 

}