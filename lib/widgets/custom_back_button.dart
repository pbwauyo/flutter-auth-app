import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget{
  final BuildContext currentContext;

  CustomBackButton({@required this.currentContext});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(currentContext);
      },
      child: Icon(
        CupertinoIcons.left_chevron, 
        color: Colors.black, size: 32,
      ),
    );
  }
}