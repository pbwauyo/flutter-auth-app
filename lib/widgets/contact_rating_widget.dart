import 'dart:math';

import 'package:auth_app/getxcontrollers/contact_slider_controller.dart';
import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/widgets/contact_avatar.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class ContactRatingWidget extends StatefulWidget {

  final HapprContact happrContact;

  ContactRatingWidget({@required this.happrContact});

  @override
  _ContactRatingWidgetState createState() => _ContactRatingWidgetState();
}

class _ContactRatingWidgetState extends State<ContactRatingWidget> {
  final ContactSliderController _contactSliderController = Get.put(ContactSliderController());

  double _sliderValue = 1.0;

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
              ContactAvatar(
                initials: widget.happrContact.initials,
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
            max: 4.0,
            divisions: 3,
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