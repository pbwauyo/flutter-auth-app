import 'dart:io';

import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomImageFilter extends StatelessWidget {
  final File image;
  final Color color;
  final BlendMode blendMode;
  final double size;
  final VoidCallback onTap;
  final double opacity;
  final String filterName;
  final bool isSelected;

  CustomImageFilter({@required this.image, this.color = Colors.redAccent, this.blendMode = BlendMode.saturation, 
  this.size = 40, @required this.onTap, this.opacity = 1.0, this.filterName = "No Filter", this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            overflow: Overflow.visible,
            children: [
              Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size/2),
                  image: DecorationImage(
                    image: FileImage(image),
                    colorFilter: blendMode != null ? ColorFilter.mode(color.withOpacity(opacity), blendMode) : null,
                    fit: BoxFit.cover,
                    onError: (error, stackTrace){
                      Methods.showCustomSnackbar(
                        context: context, 
                        message: "$error"
                      );
                    }
                  )
                ),
              ),

              Positioned(
                top: -4,
                right: -4,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: isSelected ? 1 : 0,
                  child: Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26/2),
                      color: Colors.green
                    ),
                    child: Icon(Icons.done, color: Colors.white,),
                  )
                )
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: CustomTextView(
              text: filterName,
              textColor: Colors.white,
              fontSize: 16,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
  
}