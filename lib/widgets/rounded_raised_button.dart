import 'package:auth_app/utils/constants.dart';
import 'package:flutter/material.dart';

import 'custom_progress_indicator.dart';
import 'custom_text_view.dart';

class RoundedRaisedButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final double fontSize;
  final bool bold;
  final double borderRadius;
  final double elevation;
  final EdgeInsets padding;
  final VoidCallback onTap;
  final bool showProgress;
  final Color borderColor;
  final Icon leadingIcon;

  RoundedRaisedButton({@required this.text, this.bgColor = AppColors.PRIMARY_COLOR, 
      this.borderRadius = 25, this.elevation = 3.0, this.textColor = Colors.black, 
      this.fontSize = 16, this.bold = false, this.padding, @required this.onTap, 
      this.showProgress = false, this.borderColor = AppColors.PRIMARY_COLOR, this.leadingIcon});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: padding ?? EdgeInsets.symmetric(vertical: 15),
      elevation: elevation,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor)
      ),
      disabledColor: AppColors.PRIMARY_COLOR,
      disabledElevation: elevation,
      onPressed: showProgress ? null : onTap,
      child: Container(
        child: !showProgress ? 
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5.0),
                  child: leadingIcon
                ) ?? Container(),
                CustomTextView(
                  text: text,
                  fontSize: fontSize,
                  bold: bold,
                  textColor: textColor,
                ),
              ],
            ),
          ) :
          CustomProgressIndicator(size: fontSize, color: Colors.white,)
      ),
    );
  }
}