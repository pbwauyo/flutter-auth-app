import 'package:flutter/material.dart';

class EmptyResultsText extends StatelessWidget{
  final String message;

  EmptyResultsText({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message ?? "No results to display",
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 20
        ),
      ),
    );
  }
}