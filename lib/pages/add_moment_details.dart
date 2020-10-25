import 'package:auth_app/getxcontrollers/create_moment_controller.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/pages/moment_in_progress.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

final Map<String, String> momentImages = {
  "Food" : AssetNames.FOOD_LARGE,
  "Animals" : AssetNames.ANIMALS,
  "Beach" : AssetNames.BEACH_LARGE,
  "Dining" : AssetNames.DINING_LARGE,
  "Family" : AssetNames.FAMILY_LARGE,
  "Fashion" : AssetNames.FASHION_LARGE,
  "Museum" : AssetNames.MUSEUM_LARGE,
  "People" : AssetNames.PEOPLE_LARGE,
  "Travel" : AssetNames.TRAVEL_LARGE
};

class AddMomentDetails extends StatefulWidget {
  @override
  _AddMomentDetailsState createState() => _AddMomentDetailsState();
}

class _AddMomentDetailsState extends State<AddMomentDetails> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateTimeController = TextEditingController(); 
  final _attendeesController = TextEditingController(); 
  final _notesController = TextEditingController();
  final _namesController = TextEditingController();
  final CreateMomentController _createMomentController = Get.find();
 
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              height: 160,
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(momentImages[_createMomentController.categoryName.value]),
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
        ),

        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextView(
                text: "Give a title to your happy moment"
              ),
              Container(
                child: CustomInputField(
                  placeholder: "Write here", 
                  controller: _titleController,
                  suffixWidget: Align(
                    alignment: Alignment.centerRight,
                    child: Ring(size: 25, width: 4,)
                  ),
                  drawUnderlineBorder: true,
                ),
              )
            ],
          ),
        ),

        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                  text: "Where do you want it to happen?"
                ),
                Container(
                  child: CustomInputField(
                    placeholder: "Write a location", 
                    controller: _locationController,
                    prefixIcon: Icons.location_on,
                    suffixWidget: Align(
                      alignment: Alignment.centerRight,
                      child: Ring(size: 25, width: 4,)
                    ),
                    drawUnderlineBorder: true,
                  ),
                )
              ],
            ),
          ),
        ),

        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                  text: "Who do you want to attend with?"
                ),
                Container(
                  child: CustomInputField(
                    placeholder: "Start by typing names", 
                    controller: _attendeesController,
                    prefixIcon: Icons.person,
                    suffixWidget: Align(
                      alignment: Alignment.centerRight,
                      child: Ring(size: 25, width: 4,)
                    ),
                    drawUnderlineBorder: true,
                  ),
                )
              ],
            ),
          ),
        ),

        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                  text: "When do you want it to happen?"
                ),
                Container(
                  child: CustomInputField(
                    placeholder: "Date & Time", 
                    controller: _dateTimeController,
                    prefixIcon: Icons.schedule,
                    suffixWidget: Align(
                      alignment: Alignment.centerRight,
                      child: Ring(size: 25, width: 4,)
                    ),
                    drawUnderlineBorder: true,
                  ),
                )
              ],
            ),
          ),
        ),

        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                  text: "Notes"
                ),
                Container(
                  child: CustomInputField(
                    placeholder: "Write here", 
                    controller: _notesController,
                    drawUnderlineBorder: true,
                  ),
                )
              ],
            ),
          ),
        ),

        Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 35),
              child: RoundedRaisedButton(
                text: "Make it happen", 
                onTap: (){
                  final title = _titleController.text.trim();
                  final location = _locationController.text.trim();
                  final attendees = _attendeesController.text.trim();
                  final dateTime = _dateTimeController.text.trim();
                  final notes = _notesController.text.trim();

                  final moment = Moment(
                    title: title,
                    location: location,
                    attendees: attendees,
                    dateTime: dateTime,
                    notes: notes,
                    category: _createMomentController.categoryName.value
                  );

                  Navigations.goToScreen(context, MomentInProgress(moment: moment));
                }
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _dateTimeController.dispose();
    _notesController.dispose();
    _namesController.dispose();
    _attendeesController.dispose();
    super.dispose();
  }
}