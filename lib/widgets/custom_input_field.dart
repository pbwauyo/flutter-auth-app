import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final BuildContext buildContext;
  final String placeholder;
  final TextEditingController controller;
  final IconData prefixIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final bool showIcon;
  final bool drawUnderlineBorder;
  final double widthFactor;
  final int maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final bool isLast;

  CustomInputField({this.buildContext, @required this.placeholder, @required this.controller, this.widthFactor = 0.8,
    this.prefixIcon, this.textInputType, this.obscureText = false, this.showIcon = true, this.drawUnderlineBorder = false, 
    this.maxLength, this.textAlign = TextAlign.center, this.focusNode, this.nextFocusNode, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: _screenWidth * widthFactor,
      child: TextField(
        focusNode: focusNode ?? FocusNode(),
        onChanged: (value){
          if(value.length > 0){
            if(isLast){
              FocusScope.of(context).unfocus();
            }else{
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          }
          
        },
        textAlign: textAlign,
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