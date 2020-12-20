import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final double size;
  final String assetImage;

  ImageContainer({this.size = 30, @required this.assetImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size/2),
        image: DecorationImage(
          image: AssetImage(assetImage),
          fit: BoxFit.contain
        )
      ),
    );
  }
}