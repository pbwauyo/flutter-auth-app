import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final IconData prefixIcon;
  final TextInputType textInputType;
  final bool obscureText;

  CustomInputField({@required this.placeholder, @required this.controller, 
    @required this.prefixIcon, this.textInputType, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: _screenWidth * 0.8,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: placeholder,
          prefixIcon: Icon(prefixIcon, size: 24,)
        ),
        keyboardType: textInputType ?? TextInputType.text,
        obscureText: obscureText,
      ),
    );
  }
}