import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';

typedef void OnTap(String label);

class InterestCategoryItem extends StatelessWidget {
  final String label;
  final OnTap onTap;
  final bool isSelected;

  InterestCategoryItem({@required this.label, @required this.onTap, this.isSelected =  false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap(label);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300)
            ),
            child: Icon(Icons.done, 
              size: 20,
              color: isSelected ? Colors.green : Colors.black,
            )
          ),

          CustomTextView(
            text: label
          )
        ],
      ),
    );
  }
}