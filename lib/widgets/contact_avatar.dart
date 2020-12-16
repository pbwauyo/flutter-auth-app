import 'dart:math';

import 'package:flutter/material.dart';

import 'custom_text_view.dart';

final List<Color> colors = [
    Color(0xFFFF6D6D),
    Color(0xFFB98E00),
    Color(0xFF5038B1),
    Color(0xFF138B5B),
    Color(0xFF6D99FF),
];

class ContactAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final double fontSize;

  ContactAvatar({this.initials, this.size = 80, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    final colorIndex = Random().nextInt(colors.length);
    
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 8),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors[colorIndex],
        borderRadius: BorderRadius.circular(size/2)
      ),
      child: Center(
        child: CustomTextView(
          text: initials,
          textColor: Colors.white,
          fontSize: fontSize,
        ),
      ),
    );
  }
}