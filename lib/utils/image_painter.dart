import 'package:auth_app/getxcontrollers/edit_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class ImagePainter extends CustomPainter {
  final Color color;
  final double size;
  final EditImageController _editImageController = Get.find();

  ImagePainter({this.color = Colors.white, this.size = 5});

  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint painter = new Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.fill;

    for(Offset offset in _editImageController.paintPoints){
      canvas.drawCircle(offset, 5, painter);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}