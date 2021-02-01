import 'package:auth_app/pages/calendar_permission.dart';
import 'package:auth_app/pages/contacts_list.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/interests_v2.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPermission extends StatelessWidget {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      width: 120,
                      height: 120,
                      child: SvgPicture.asset(AssetNames.CIRCLE_SVG, width: 110, height: 110,),
                    ),

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
                        text: "Now that you're taking control, you know that true happiness starts with true relationships, in the next step, please select only the people who truly care you & you truly care about them.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: RoundedRaisedButton(
                      borderRadius: 25,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      text: "Start building my circle", 
                      onTap: () async{
                        final contactsPermissionStatus = await Permission.contacts.request(); 
                        if(contactsPermissionStatus.isGranted){
                          Navigations.goToScreen(context, ContactsList());
                        }else{
                          Navigations.goToScreen(context, InterestsV2());
                        }
                        
                      }
                    ),
                  ),
                ),
              )
            ],
          ),

           Positioned(
            bottom: 10,
            right: 10,
            child: Ring(
              size: 25,
              width: 4,
            )
          ),

          Positioned(
            bottom: 60,
            left: -15,
            child: Ring(
              size: 50,
              width: 4,
            )
          ),
        ],
      ),
    );
  }
}