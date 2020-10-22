import 'dart:math';

import 'package:auth_app/getxcontrollers/contact_slider_controller.dart';
import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

final List<Color> colors = [
  Color(0xFFFF6D6D),
  Color(0xFFB98E00),
  Color(0xFF5038B1),
  Color(0xFF138B5B),
  Color(0xFF6D99FF),
];

class ContactRatingWidget extends StatelessWidget {

  final HapprContact happrContact;
  final ContactSliderController _contactSliderController = Get.put(ContactSliderController());

  ContactRatingWidget({@required this.happrContact});

  @override
  Widget build(BuildContext context) {
    final colorIndex = Random().nextInt(colors.length);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 8),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors[colorIndex],
                borderRadius: BorderRadius.circular(40.0)
              ),
              child: CustomTextView(
                text: "${happrContact.initials}",
                textColor: Colors.white,
              ),
            ),

            CustomTextView(
              text: "${happrContact.displayName}"
            ),
          ],
        ),
        
        Obx(()=> Container(
            width: 150,
            child: Slider(
              min: 0.0,
              max: 10.0,
              divisions: 10,
              value: _contactSliderController.sliderValue.value, 
              onChanged: (newValue){
                _contactSliderController.updateValue(newValue);
              },
              onChangeEnd: (newValue){

              },
            ),
          ) 
        )
      ],
    );
  }
}