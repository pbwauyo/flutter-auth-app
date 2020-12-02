import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final VoidCallback ontap;
  final double size;
  final Color color;

  PlayButton({@required this.ontap, this.size = 50, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        height: size,
        width: size,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2.0),
          borderRadius: BorderRadius.circular(size/2)
        ),   
        child: Icon(Icons.play_arrow_sharp, 
          size: 32,
          color: color
        ),
      ),
    );
  }
}