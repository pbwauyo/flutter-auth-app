import 'package:auth_app/utils/constants.dart';
import 'package:flutter/material.dart';

typedef OnChanged(String value);

class CustomInputField extends StatelessWidget {
  final BuildContext buildContext;
  final String placeholder;
  final TextEditingController controller;
  final IconData prefixIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final bool drawUnderlineBorder;
  final double widthFactor;
  final int maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final bool isLast;
  final OnChanged onChanged;
  final VoidCallback onEditingComplete;
  final IconData suffixIcon;
  final Color suffixIconColor;
  final Color textColor;

  CustomInputField({this.buildContext, @required this.placeholder, @required this.controller, this.widthFactor = 0.8,
    this.prefixIcon, this.textInputType, this.obscureText = false, this.drawUnderlineBorder = false, 
    this.maxLength, this.textAlign = TextAlign.center, this.focusNode, this.nextFocusNode, this.isLast = false, this.onChanged, 
    this.onEditingComplete, this.suffixIcon, this.suffixIconColor = AppColors.LIGHT_GREY_TEXT, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: _screenWidth * widthFactor,
      child: TextField(
        style: TextStyle(
          color: textColor
        ),
        focusNode: focusNode ?? FocusNode(),
        onChanged: (value){
          if(onChanged != null){
            onChanged(value);
          }else {
            if(value.length > 0){
              if(isLast){
                FocusScope.of(context).unfocus();
              }else{
                FocusScope.of(context).requestFocus(nextFocusNode);
              }
            }
          }
          
        },
        onEditingComplete: onEditingComplete ?? (){},
        textAlign: textAlign,
        controller: controller,
        maxLength: maxLength,
        decoration: InputDecoration(
          border: drawUnderlineBorder ? UnderlineInputBorder() : InputBorder.none,
          hintText: placeholder,
          counterText: "",
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: suffixIconColor) : null,
        ),
        keyboardType: textInputType ?? TextInputType.text,
        obscureText: obscureText,
      ),
    );
  }
}