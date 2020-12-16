import 'package:flutter/material.dart';

class DragPlaceholder extends StatelessWidget {
  final double size;
  final Color color;

  DragPlaceholder({this.size = 60, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade400,
        borderRadius: BorderRadius.circular(size/2)
      ),
    );
  }
}