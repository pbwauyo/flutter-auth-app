import 'dart:io';

import 'package:auth_app/getxcontrollers/contacts_controller.dart';
import 'package:auth_app/getxcontrollers/create_moment_controller.dart';
import 'package:auth_app/getxcontrollers/selected_calendar_controller.dart';
import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/pages/moment_in_progress.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_type_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/happr_contact_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/calendar_dropdown.dart';
import 'package:auth_app/widgets/contact_avatar.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/empty_results_text.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:camera/camera.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

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
  final Moment moment;

  AddMomentDetails({this.moment});

  @override
  _AddMomentDetailsState createState() => _AddMomentDetailsState();
}

class _AddMomentDetailsState extends State<AddMomentDetails> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateTimeController = TextEditingController(); 
  final _endDateTimeController = TextEditingController(); 
  final _attendeesController = TextEditingController(); 
  final _notesController = TextEditingController();
  final _namesController = TextEditingController();
  final CreateMomentController _createMomentController = Get.find();
  final SelectedCalendarController _selectedCalendarController = Get.find();
  final HapprContactsController _happrContactsController = Get.put(HapprContactsController());
  final _autoCompleteTextFieldKey = GlobalKey<AutoCompleteTextFieldState<HapprContact>>();

  Future<List<HapprContact>> _happrContactsFuture;

  final _happrContactsRepo = HapprContactRepo();
  DateTime _startDateTime;
  DateTime _endDateTime;

  @override
  void initState() {
    super.initState();
    _happrContactsFuture = _fetchAllHapprContacts();
    if(widget.moment != null){
      final _moment = widget.moment;
      _titleController.text = _moment.title;
      _locationController.text = _moment.location;
      _startDateTimeController.text = _moment.startDateTime;
      _endDateTimeController.text = _moment.endDateTime ?? "";
      _notesController.text = _moment.notes;

      print("CALENDAR ID VALUE: ${_moment.calendarId}");
      _selectedCalendarController.calendarId.value = _moment.calendarId;
      _startDateTime = _moment.realStartDateTime;
      _endDateTime = _moment.realEndDateTime;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final momentType = Provider.of<MomentTypeProvider>(context, listen: false).momentType;
    
    return Builder(
      builder: (newContext) {
        return ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.8,
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
                          FutureBuilder<ImageProvider>(
                            future: Methods.generateImageProvider(mediaPath: imagePath),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                final imageProvider = snapshot.data;
                                return Container(
                                  height: 160,
                                  margin: const EdgeInsets.only(top: 10, bottom: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover
                                    )
                                  ),
                                );

                              }else if(snapshot.hasError){
                                return Center(
                                  child: ErrorText(error: "${snapshot.error}"),
                                );

                              }else{
                                return Center(
                                  child: CustomProgressIndicator(),
                                );
                                
                              }
                            }
                          );
                      }
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () async{
                        final cameras = await availableCameras();
                        final photoPermission = Permission.photos;

                        if(!await photoPermission.isGranted){
                          final permissionRequestStatus = await photoPermission.request();  //this will help in showing the gallery images
                          if(!(permissionRequestStatus == PermissionStatus.granted)){
                            return;
                          }
                        }

                        Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType = MOMENT_IMAGE_ADD;
                        Navigations.goToScreen(
                          context, 
                          ChangeMomentImage(cameras: cameras),
                        );
                        
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Icon(
                          Icons.camera_alt, 
                          size: 32,
                          color: Colors.white,
                          semanticLabel: "Change image",
                        ),
                      ),
                    )
                  )
                ],
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
                width: screenWidth * 0.8,
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(
                      text: "Who do you want to attend with?"
                    ),
                    FutureBuilder<List<HapprContact>>(
                      future: _happrContactsFuture,
                      builder: (context, snapshot) {

                        if(snapshot.hasData){
                          final happrContacts = snapshot.data;

                          if(happrContacts.length <= 0){
                            return Center(
                              child: EmptyResultsText(message: "No contacts to show")
                            );
                          }

                          return Container(
                            child: Obx((){
                              print('CURRENT CONTACTS: ${_happrContactsController.contacts.length}');
                              return AutoCompleteTextField<HapprContact>(
                                controller: _attendeesController,
                                itemSubmitted: (contact){
                                  _happrContactsController.contacts.add(contact);
                                  _attendeesController.text = "";
                                }, 
                                key: _autoCompleteTextFieldKey, 
                                suggestions: happrContacts, 
                                itemBuilder: (context, contactSuggestion){
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 6, right: 6, top: 5, ),
                                    child: ListTile(
                                      leading: ContactAvatar(
                                        initials: contactSuggestion.initials,
                                        size: 30,
                                      ),
                                      title: CustomTextView(
                                        fontSize: 13,
                                        text: contactSuggestion.displayName
                                      ),
                                    )
                                  );
                                }, 
                                itemSorter: (contact_1, contact_2){
                                  return 0;
                                }, 
                                itemFilter: (contactSuggestion, query){
                                  return contactSuggestion.displayName.toLowerCase().contains(query.toLowerCase());
                                },
                                clearOnSubmit: false,
                                decoration: InputDecoration(
                                  hintText: _happrContactsController.contacts.length <= 0 ? "Start by typing names" : "Add more people", //bug here
                                  prefixIcon: Icon(Icons.person, color: AppColors.PRIMARY_COLOR,) ,
                                  suffixIcon: Icon(Icons.trip_origin, color: AppColors.PRIMARY_COLOR,),
                                  border: InputBorder.none
                                ),
                              );
                            }),
                          );
                        }else if(snapshot.hasError){
                          return Center(
                            child: ErrorText(error: "${snapshot.error}"),
                          );
                        }
                        return Center(
                          child: CustomProgressIndicator(),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),

            Center(
              child: Container(
                width: screenWidth * 0.8,
                child: Obx((){
                  return Wrap(
                    spacing: 3.0,
                    runSpacing: 2.0,
                    children: _happrContactsController.contacts.map(
                      (contact) => Container(
                        padding: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ContactAvatar(
                              initials: contact.initials,
                              size: 30,
                            ),
                            Container(
                              // margin: const EdgeInsets.only(right: 3),
                              child: IconButton(
                                padding: EdgeInsets.all(0.0),
                                icon: Icon(Icons.clear),
                                color: Colors.red,
                                onPressed: (){
                                  _happrContactsController.contacts.remove(contact);
                                }
                              ),
                            ),
                          ],
                        ),
                      )
                    ).toList(),
                  );
                })
              ),
            ),

            Center(
              child: Container(
                width: screenWidth * 0.8,
                child: Divider(thickness: 1.5, color: AppColors.LIGHT_GREY_TEXT,)
              ),
            ),

            Center(
              child: Container(
                width: screenWidth * 0.8,
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
                            onConfirm: (startDateTime){
                              _startDateTime = startDateTime;
                              final day = startDateTime.day;
                              final month = Constants.months[startDateTime.month-1];
                              final year = startDateTime.year;
                              final hour = startDateTime.hour;
                              final minute = startDateTime.minute;
                              _startDateTimeController.text = "$hour:$minute, $day $month, $year";
                              
                            },
                            onChanged: (dateTime){
                              
                            },
                            currentTime: DateTime.now()
                          );
                        },
                        child: AbsorbPointer(
                          child: CustomInputField(
                            textAlign: TextAlign.start,
                            placeholder: "Start Date & Time", 
                            controller: _startDateTimeController,
                            prefixIcon: Icons.schedule,
                            suffixIcon: Icons.trip_origin,
                            drawUnderlineBorder: true,
                            suffixIconColor: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      child: GestureDetector(
                        onTap: (){
                          DatePicker.showDateTimePicker(context,
                            minTime: DateTime(1990),
                            maxTime: DateTime(2030),
                            onConfirm: (endDateTime){
                              _endDateTime = endDateTime;
                              final day = endDateTime.day;
                              final month = Constants.months[endDateTime.month-1];
                              final year = endDateTime.year;
                              final hour = endDateTime.hour;
                              final minute = endDateTime.minute;
                              _endDateTimeController.text = "$hour:$minute, $day $month, $year";
                              
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
                            placeholder: "End Date & Time", 
                            controller: _endDateTimeController,
                            prefixIcon: Icons.schedule,
                            suffixIcon: Icons.trip_origin,
                            drawUnderlineBorder: true,
                            suffixIconColor: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: CalendarDropDown(),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: RoundedRaisedButton(
                        text: "VIEW CALENDER", 
                        onTap: () async{
                          await _openCalendar(newContext);
                        }
                      ),
                    )
                  ],
                ),
              ),
            ),

            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 5),
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
                    text: (widget.moment == null || momentType == MOMENT_TYPE_ONE_CLICK) ? "Make it happen" : "Update Moment", 
                    onTap: (){
                      final List<Map<String, String>> attendees = [];
                      _happrContactsController.contacts.forEach((contact) {
                          attendees.add({
                            "id" : "${contact.id}",
                            "displayName" : contact.displayName,
                            "phoneNumber" : contact.phone
                          });
                         }
                      );

                      _happrContactsController.contacts.clear();

                      final title = _titleController.text.trim();
                      final location = _locationController.text.trim();
                      final startDateTime = _startDateTimeController.text.trim();
                      final endDateTime = _endDateTimeController.text.trim();
                      final notes = _notesController.text.trim();

                      Moment _moment;

                      if(widget.moment != null){
                        _moment = widget.moment;
                        _moment.title = title;
                        _moment.location = location;
                        _moment.startDateTime = startDateTime;
                        _moment.endDateTime = endDateTime;
                        _moment.notes = notes;
                        _moment.attendees = attendees;
                        _moment.realStartDateTime = _startDateTime;
                        _moment.realEndDateTime = _endDateTime;
                        
                      }else{
                        _moment = Moment(
                          title: title,
                          location: location,
                          attendees: attendees,
                          startDateTime: startDateTime,
                          notes: notes,
                          category: _createMomentController.categoryName.value,
                          endDateTime: endDateTime,
                          calendarId: _selectedCalendarController.calendarId.value,
                          realStartDateTime: _startDateTime,
                          realEndDateTime: _endDateTime
                        );
                      }

                      Navigations.goToScreen(context, MomentInProgress(moment: _moment));
                    }
                  ),
                ),
              ),
            )
          ],
        );
      }
    );
  }

  Future<List<HapprContact>> _fetchAllHapprContacts() async{
    final happrContactsList =  await _happrContactsRepo.getAllHapprContacts();
    return happrContactsList;
  }

  Future<void> _openCalendar(BuildContext context) async{
    try{
      if(Platform.isAndroid){
        const androidCalendarUrl = "content://com.android.calendar/time/";
        if(await canLaunch(androidCalendarUrl)){
          await launch(androidCalendarUrl);
        }else{
          Methods.showCustomSnackbar(
            context: context, 
            message: "Failed to open Calendar"
          );
        }
      }else if(Platform.isIOS){
        const iOSCalendarUrl = "calshow://";
        if(await canLaunch(iOSCalendarUrl)){
          await launch(iOSCalendarUrl);
        }else{
          Methods.showCustomSnackbar(
            context: context, 
            message: "Failed to open Calendar"
          );
        }
      }
    }catch(err){
      Methods.showCustomSnackbar(
        context: context, 
        message: "Error while opening calendar: $err"
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _startDateTimeController.dispose();
    _notesController.dispose();
    _namesController.dispose();
    _attendeesController.dispose();
    Provider.of<MomentTypeProvider>(context, listen: false).momentType = "";
    super.dispose();
  }
}