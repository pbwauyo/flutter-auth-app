import 'dart:math';

import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/repos/happr_contact_repo.dart';
import 'package:auth_app/utils/constants.dart';
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
  final _happrContactRepo = HapprContactRepo();  

  double _sliderValue = 0.0;

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
        
        Stack(
          children: [
            Positioned(
              top: 23.0,
              left: 15,
              child: Container(
                width: 120,
                height: 4.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey, Colors.green, Colors.blue, Colors.yellow],
                    stops: [0.1, 0.4, 0.6, 0.8]
                  ),
                  borderRadius: BorderRadius.circular(8.0)
                ),
              ),
            ),

            Container(
              width: 150,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  valueIndicatorColor: Constants.SLIDER_LABEL_COLORS[_sliderValue],
                  thumbColor: Constants.SLIDER_LABEL_COLORS[_sliderValue],
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent
                ),
                child: Slider(
                  min: 0.0,
                  max: 3.0,
                  label: Constants.SLIDER_LABELS[_sliderValue],
                  divisions: 3,
                  value: _sliderValue, 
                  onChanged: (newValue){
                    setState(() {
                      _sliderValue = newValue;
                    });
                  },
                  onChangeEnd: (newValue){
                    _happrContactRepo.setHapprContactRating(
                      happrContact: widget.happrContact, 
                      rating: newValue
                    );
                  },
                ),
              ),
            ),

          ],
        )
      ],
    );
  }
}