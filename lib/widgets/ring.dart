import 'package:auth_app/utils/constants.dart';
import 'package:flutter/material.dart';

class Ring extends StatelessWidget {
  final double size;
  final Color color;
  final double width;

  Ring({this.size = 20, this.color = AppColors.PRIMARY_COLOR, this.width = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size/2),
        border: Border.all(width: width, color: color)
      ),
    );
  }
}