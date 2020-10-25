import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatelessWidget {
  
  final String image;
  final String title;
  final String body;
  final VoidCallback onTap;

  CustomCard({@required this.image, @required this.title, @required this.body, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(image,
                  height: 100,
                  width: 80,
                  fit: BoxFit.cover,
                ),

                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: CustomTextView(
                    textAlign: TextAlign.center,
                    text: title,
                    bold: true,
                  ),
                ),

                CustomTextView(
                  text: body,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}