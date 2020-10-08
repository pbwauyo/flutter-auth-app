import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final IconData prefixIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final bool showIcon;
  final bool drawUnderlineBorder;
  final double widthFactor;
  final int maxLength;

  CustomInputField({@required this.placeholder, @required this.controller, this.widthFactor = 0.8,
    this.prefixIcon, this.textInputType, this.obscureText = false, this.showIcon = true, this.drawUnderlineBorder = false, this.maxLength});

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: _screenWidth * widthFactor,
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        maxLength: maxLength,
        decoration: InputDecoration(
          border: drawUnderlineBorder ? UnderlineInputBorder() : InputBorder.none,
          hintText: placeholder,
          counterText: ""
        ),
        keyboardType: textInputType ?? TextInputType.text,
        obscureText: obscureText,
      ),
    );
  }
}