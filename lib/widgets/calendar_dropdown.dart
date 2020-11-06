import 'dart:collection';

import 'package:auth_app/getxcontrollers/selected_calendar_controller.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/empty_results_text.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class CalendarDropDown extends StatefulWidget {

  @override
  _CalendarDropDownState createState() => _CalendarDropDownState();
}

class _CalendarDropDownState extends State<CalendarDropDown> {
  Future<UnmodifiableListView<Calendar>> _calendarFuture;
  DeviceCalendarPlugin _deviceCalendarPlugin;
  SelectedCalendarController _selectedCalendarController = Get.find();

  @override
  void initState() {
    super.initState();
    _deviceCalendarPlugin = DeviceCalendarPlugin();
    _calendarFuture = fetchCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UnmodifiableListView<Calendar>>(
      future: _calendarFuture,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final calendars = snapshot.data;
          if(calendars.length <= 0){
            return Center(
              child: EmptyResultsText(message: "No calendars available",),
            );
          }
          _selectedCalendarController.calendarId.value = calendars.first.id;
          return Obx(() =>
            DropdownButton<String>(
              hint: CustomTextView(text: "Select calendar to use"),
              isExpanded: true,
              items: calendars.map(
                (calendar) => 
                  DropdownMenuItem(
                    value: calendar.id,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                      child: Text(calendar.accountName),
                    )
                  )
                ).toList(), 
              value: _selectedCalendarController.calendarId.value,
              onChanged: (value){
                _selectedCalendarController.calendarId.value = value;
              }
            )
          );
        }
        else if(snapshot.hasError){
          return Center(
            child: ErrorText(error: "${snapshot.error}"),
          );
        }
        else {
          return Center(
            child: CustomProgressIndicator(),
          );
        }
      }
    );
  }

  Future<UnmodifiableListView<Calendar>> fetchCalendars () async{
    final calendarPermission = Permission.calendar;
    if(!await calendarPermission.isGranted){
      final permissionsStatus = await calendarPermission.request();
      if(!permissionsStatus.isGranted){
        throw("Calendar permissions are required");
      }
    }
    final calendars = await _deviceCalendarPlugin.retrieveCalendars();
    return calendars.data;
  }
}