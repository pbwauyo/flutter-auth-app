import 'package:auth_app/models/memory.dart';
import 'package:auth_app/widgets/circle_profile_image.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';

class MemoryWidget extends StatelessWidget{
  final Memory memory;
  final double width;
  final double height;

  MemoryWidget({@required this.memory, this.width = 160, this.height = 160});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Stack(
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Container(
              height: height,
              width: width,
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
 