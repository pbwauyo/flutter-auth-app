import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';

class TextImageFilter extends StatelessWidget {
  final double size;
  final String text;
  final VoidCallback onTap;

  TextImageFilter({@required this.text, @required this.onTap, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(size/2),
        ),
        child: CustomTextView(
          text: text,
          textColor: Colors.white
        ),
      ),
    );
  }

}