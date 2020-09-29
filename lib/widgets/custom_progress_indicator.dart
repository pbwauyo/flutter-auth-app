import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget{
  final Color color;
  final double size;

  CustomProgressIndicator({this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size ?? 20,
        height: size ?? 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(color ?? Colors.yellow),
        ),
      ),
    );
  }

}