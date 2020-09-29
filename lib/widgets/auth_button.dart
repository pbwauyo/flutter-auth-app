import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onTap;

  AuthButton({@required this.text, @required this.icon, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.only(left: 6, right: 6),
      onPressed: onTap, 
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: icon
            ),
            Expanded(
              child: Text(text,
                style: TextStyle(
                  color: Colors.white
                ),   
              ),
            )
          ],
        ),
      )
    );
  }

  
}