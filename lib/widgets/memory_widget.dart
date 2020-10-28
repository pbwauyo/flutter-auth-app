import 'package:auth_app/models/memory.dart';
import 'package:auth_app/widgets/circle_profile_image.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';

class MemoryWidget extends StatelessWidget{
  final Memory memory;
  final double size = 160;

  MemoryWidget({@required this.memory});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      child: Stack(
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(memory.image),
                  fit: BoxFit.cover
                )
              ),
            ),
          ),

          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              child: CircleProfileImage(
                username: "na",
                size: 30,
                showBorder: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
 