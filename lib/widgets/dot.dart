import 'package:auth_app/utils/constants.dart';
import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final Color color;
  final double size;
  final VoidCallback onTap;

  Dot({this.color, this.size = 20, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? AppColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(size/2),
          border: Border.all(color: Colors.white, width: 1.0)
        ),
      ),
    );
  }

}