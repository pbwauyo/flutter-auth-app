import 'package:auth_app/getxcontrollers/contacts_list_controller.dart';
import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/pages/interests.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/contact_rating_widget.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:rxdart/subjects.dart';

class ContactsList extends StatelessWidget {
  final ContactsListController _contactsListController = Get.put(ContactsListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(AssetNames.APP_LOGO_SVG, width: 100, height: 35,),
        elevation: 0.0,
        backgroundColor: Colors.white
      ),
      body: Stack(
        children: [
          Column(
            children: [
               Container(
                margin: const EdgeInsets.only(top: 20),
                child: CustomTextView(
                  text: "My happr circle",
                  fontSize: 18,
                  bold: true,
                ),
              ),

              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: CustomTextView(
                  text: "Let's build your circle based on the amount of time you'd like to spend with them.",
                  textAlign: TextAlign.center,
                ),
              ),
              
              Expanded(
                child: Obx((){
                  if(_contactsListController.contacts.length <= 0){
                    return Center(
                      child: CustomProgressIndicator(size: 40,)
                    );
                  }

                  return ListView.builder(
                    padding:  const EdgeInsets.only(left: 10, right: 10, bottom: 5.0),
                    itemCount: _contactsListController.contacts.length,
                    itemBuilder: (context, index){
                      final contact = _contactsListController.contacts[index];
                      final happrContact = HapprContact(
                        displayName: contact.displayName,
                        initials: contact.initials(),
                      );
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: ContactRatingWidget(happrContact: happrContact)
                        )
                      );
                    }
                  );
                })
              )
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: RoundedRaisedButton(
                  borderRadius: 25,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  text: "Next", 
                  onTap: () async{
                    Navigations.goToScreen(context, Interests());
                  }
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}