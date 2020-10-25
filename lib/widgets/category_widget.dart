import 'package:auth_app/models/category.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  CategoryWidget({@required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: AssetImage(category.image),
              fit: BoxFit.cover
            )
          ),
        ),

        CustomTextView(
          text: category.name
        )
      ],
    );
  }
}