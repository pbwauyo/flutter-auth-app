import 'package:auth_app/getxcontrollers/logged_in_username.dart';
import 'package:auth_app/getxcontrollers/selected_calendar_controller.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:provider/provider.dart';

class MomentRepo {
  final _firestore = FirebaseFirestore.instance;
  final _userRepo = UserRepo();
  final LoggedInUsernameController _loggedInUsernameController = Get.find();
  final SelectedCalendarController _selectedCalendarController = Get.find();

  CollectionReference get _allMomentsCollectionRef => _firestore.collection("moments");

  Future<void> saveMoment(BuildContext context, Moment moment) async{
    if(moment.id == null || moment.id.isEmpty){
      final id = _allMomentsCollectionRef.doc().id;
      moment.id = id;
    } 

    final filePathProvider =  Provider.of<FilePathProvider>(context, listen: false);
    final photoPath = filePathProvider.filePath;
    if(photoPath.trim().length > 0){
      if(photoPath.startsWith("http")){
        moment.imageUrl = photoPath;
      }else{
        final downloadUrl = await _userRepo.uploadFile(filePath: photoPath, folderName: "moment_images");
        moment.imageUrl = downloadUrl;
      }
    }
    
    moment.creator = await PrefManager.getLoginUsername();
    await _allMomentsCollectionRef.doc(moment.id).set(moment.toMap(), SetOptions(merge: true));
    final result = await addOrUpdateMomentOnCalendar(moment: moment); // add to calendar
    if(result.isSuccess){
      final data = {
        "momentCalenderId": result.data,
        "calendarId" : _selectedCalendarController.calendarId.value
      };
      await _allMomentsCollectionRef.doc(moment.id).set(data, SetOptions(merge: true));
    }
    filePathProvider.filePath = ""; //reset file path
  }

  Future<Result<String>> addOrUpdateMomentOnCalendar({@required Moment moment}) async{
    List<Attendee> attendees = [];
    final deviceCalendarPlugin = DeviceCalendarPlugin();
    final calendarId = _selectedCalendarController.calendarId.value;
    final momentEvent = Event(calendarId);
    momentEvent.title = moment.title;
    momentEvent.description = moment.notes;
    momentEvent.location = moment.location;
    if(moment.momentCalenderId != null && moment.momentCalenderId.isNotEmpty){
      momentEvent.eventId = moment.momentCalenderId; 
    }
    if(moment.realStartDateTime != null){
      momentEvent.start = moment.realStartDateTime;
    }
    if(moment.realEndDateTime != null){
      momentEvent.end =  moment.realEndDateTime;
    }

    if(moment.realStartDateTime == null && moment.realEndDateTime == null){
      momentEvent.start = DateTime.now().add(Duration(days: 1));
      momentEvent.end = DateTime.now().add(Duration(days: 3));
    }

    moment.attendees.forEach((attendee) {
      attendees.add(
        Attendee(
          name: attendee["displayName"],
          role: AttendeeRole.Optional,
        )
      );
    });

    return await deviceCalendarPlugin.createOrUpdateEvent(momentEvent);
  }

  Future<void> deleteCalendarEvent(String calendarId, String eventId) async{
    final deviceCalendarPlugin = DeviceCalendarPlugin();
    await deviceCalendarPlugin.deleteEvent(calendarId, eventId);
  }

  Stream<QuerySnapshot> getMomentsAsStream(){
    return _allMomentsCollectionRef.where("creator", isEqualTo: _loggedInUsernameController.loggedInUserEmail).snapshots();
  }

  Future<void> updateMomentImage(String momentId, String filePath,) async{
    final downloadUrl = await _userRepo.uploadFile(filePath: filePath, folderName: "moment_images");
    await _allMomentsCollectionRef.doc(momentId).set({"imageUrl" : downloadUrl}, SetOptions(merge: true));
  }

  Future<void> deleteMoment({@required String momentId, String calendarId, String eventId}) async{
    await _allMomentsCollectionRef.doc(momentId).delete();
    await deleteCalendarEvent(calendarId, eventId);
  }

  // Future<void> updateMoment({@required Moment newMoment}) async{
  //   await 
  // }
}