import 'dart:ui';

import 'package:auth_app/cubit/home_cubit.dart';
import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/repos/happr_contact_repo.dart';
import 'package:auth_app/repos/moment_repo.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class MomentInProgress extends StatefulWidget {
  final Moment moment;
  final bool isAutoMoment;

  MomentInProgress({@required this.moment, this.isAutoMoment = false});

  @override
  _MomentInProgressState createState() => _MomentInProgressState();
}

class _MomentInProgressState extends State<MomentInProgress> {
  final _momentRepo = MomentRepo();
  final _happrContactsRepo = HapprContactRepo();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async{
      await _saveMoment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Material(
        color: Colors.grey.shade200.withOpacity(0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: CustomProgressIndicator(size: 200,)
            ),
            
            FractionallySizedBox(
              widthFactor: 0.6,
              child: CustomTextView(
                textAlign: TextAlign.center,
                textColor: Colors.white,
                fontSize: 18,
                text: "I'm working to make this happy moment happen"
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveMoment() async{
    final _homeCubit = context.bloc<HomeCubit>();

    try{
      if(widget.isAutoMoment){
        final contactsPermissions = Permission.contacts;

        if(!await contactsPermissions.isGranted){
          final contactsPermissionStatus = await contactsPermissions.request();

          if(contactsPermissionStatus.isGranted){
            final contacts = (await ContactsService.getContacts()).toList().sublist(1, 10);
            final currentUsername = await PrefManager.getLoginUsername();
            final happrContacts = contacts.map((contact) => HapprContact(
              id: contact.identifier,
              initials: contact.initials(),
              displayName: contact.displayName,
              rating: 0.0,
              phone: "",
              ownerUsername: currentUsername
            )).toList();
            
            happrContacts.forEach((happrContact) async{
              await _happrContactsRepo.postHapprContact(happrContact);
            });
          }
        } 
      }
      
      await _momentRepo.saveMoment(context, widget.moment);
      _homeCubit.goToInitial();
      Navigator.pop(context);
    }catch(error){
      print("Error while saving moment: $error");
    }
  }
}