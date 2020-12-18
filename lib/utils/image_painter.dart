import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auth_app/getxcontrollers/edit_image_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class ImagePainter extends CustomPainter {
  final Color color;
  final double size;
  final EditImageController _editImageController = Get.find();
  Canvas _canvas;
  ui.Picture _picture;

  ImagePainter({this.color = Colors.white, this.size = 5});

  Future<Uint8List> get recordedPainter async{
    final tempDir = await getTemporaryDirectory();
    final image = await _picture.toImage(400, 400);
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);
    final generatedFile = await File("${tempDir.path}/${Timestamp.now().nanoseconds}").writeAsBytes(
      pngBytes.buffer.asUint8List(pngBytes.offsetInBytes, pngBytes.lengthInBytes)
    );
    return generatedFile.readAsBytesSync();
  }

  @override
  void paint(Canvas canvas, Size size) {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    _canvas = Canvas(recorder);
    final Paint painter = new Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.fill;

    for(Offset offset in _editImageController.paintPoints){
      canvas.drawCircle(offset, 5, painter);
      _canvas.drawCircle(offset, 5, painter);
    }

    _picture = recorder.endRecording();
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}