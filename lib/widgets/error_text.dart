
import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget{

  final error;

  ErrorText({@required this.error});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("$error",
        style: TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

}