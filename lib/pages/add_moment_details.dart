import 'dart:io';

import 'package:auth_app/getxcontrollers/create_moment_controller.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/pages/moment_in_progress.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'change_moment_image.dart';

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
            child: GestureDetector(
              onTap: ()async{
                final cameras = await availableCameras();
                final permissionRequestStatus = await Permission.photos.request(); //this will help in showing the gallery images
                if(permissionRequestStatus == PermissionStatus.granted){
                  Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType = MOMENT_IMAGE_ADD;
                  Navigations.goToScreen(
                    context, 
                    ChangeMomentImage(camera: cameras.first),
                  );
                }
              },
              child: Consumer<FilePathProvider>(
                builder: (_, filePathProvider, child) {
                  final imagePath = filePathProvider.filePath;

                  return imagePath == null || imagePath.isEmpty?  
                    Container(
                      height: 160,
                      margin: const EdgeInsets.only(top: 10, bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(momentImages[_createMomentController.categoryName.value]),
                          fit: BoxFit.cover
                        )
                      ),
                    ) : 
                    Container(
                      height: 160,
                      margin: const EdgeInsets.only(top: 10, bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: imagePath.startsWith("http") ?
                            NetworkImage(imagePath) :
                            FileImage(File(imagePath)),
                          fit: BoxFit.cover
                        )
                      ),
                    );
                }
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
                  textAlign: TextAlign.start,
                  suffixIcon: Icons.trip_origin,
                  drawUnderlineBorder: true,
                  suffixIconColor: AppColors.PRIMARY_COLOR,
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
                    textAlign: TextAlign.start,
                    controller: _locationController,
                    prefixIcon: Icons.location_on,
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
                    textAlign: TextAlign.start,
                    placeholder: "Start by typing names", 
                    controller: _attendeesController,
                    prefixIcon: Icons.person,
                    suffixIcon: Icons.trip_origin,
                    drawUnderlineBorder: true,
                    suffixIconColor: AppColors.PRIMARY_COLOR,
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
                  child: GestureDetector(
                    onTap: (){
                      DatePicker.showDateTimePicker(context,
                        minTime: DateTime(1990),
                        maxTime: DateTime(2030),
                        onConfirm: (dateTime){
                          print("DATETIME: $dateTime");
                          final day = dateTime.day;
                          final month = Constants.months[dateTime.month-1];
                          final year = dateTime.year;
                          final hour = dateTime.hour;
                          final minute = dateTime.minute;
                          _dateTimeController.text = "$hour:$minute, $day $month $year";
                          
                          // final period = ;
                        },
                        onChanged: (dateTime){

                        },
                        currentTime: DateTime.now()
                      );
                    },
                    child: AbsorbPointer(
                      child: CustomInputField(
                        textAlign: TextAlign.start,
                        placeholder: "Date & Time", 
                        controller: _dateTimeController,
                        prefixIcon: Icons.schedule,
                        suffixIcon: Icons.trip_origin,
                        drawUnderlineBorder: true,
                        suffixIconColor: AppColors.PRIMARY_COLOR,
                      ),
                    ),
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
                    textAlign: TextAlign.start,
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