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

class ContactRatingWidget extends StatefulWidget {

  final HapprContact happrContact;

  ContactRatingWidget({@required this.happrContact});

  @override
  _ContactRatingWidgetState createState() => _ContactRatingWidgetState();
}

class _ContactRatingWidgetState extends State<ContactRatingWidget> {
  final ContactSliderController _contactSliderController = Get.put(ContactSliderController());

  double _sliderValue = 1.0;
  final colorIndex = Random().nextInt(colors.length);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
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
                child: Center(
                  child: CustomTextView(
                    text: "${widget.happrContact.initials}",
                    textColor: Colors.white,
                  ),
                ),
              ),

              Expanded(
                child: CustomTextView(
                  text: "${widget.happrContact.displayName}"
                ),
              ),
            ],
          ),
        ),
        
        Container(
          width: 150,
          child: Slider(
            min: 1.0,
            max: 3.0,
            divisions: 2,
            value: _sliderValue, 
            onChanged: (newValue){
              setState(() {
                _sliderValue = newValue;
              });
            },
            onChangeEnd: (newValue){

            },
          ),
        ) 
      ],
    );
  }
}