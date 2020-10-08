import 'package:flutter/material.dart';

class CustomTextView extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final bool bold;
  final bool showUnderline;
  final TextAlign textAlign;

  CustomTextView({@required this.text, this.textColor = Colors.black, this.showUnderline = false,
  this.fontSize = 14, this.bold = false, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      maxLines: null,
      textAlign: textAlign,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        decoration:  showUnderline ? TextDecoration.underline : TextDecoration.none
      ),
    );
  }
}