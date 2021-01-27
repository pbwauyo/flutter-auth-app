import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/location_permission.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

class CalendarPermission extends StatelessWidget {
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
                      child: SvgPicture.asset(AssetNames.CALENDAR_SVG, width: 110, height: 110,),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: CustomTextView(
                        text: "Happy Calendar",
                        fontSize: 18,
                        bold: true,
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: CustomTextView(
                        text: "happr is your happiness-obsessed personal assistant & will turn your calendar into a source of joy, fulfillment and achievement.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: RoundedRaisedButton(
                          borderRadius: 25,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          text: "Grant Calendar Access", 
                          onTap: () async{
                            final calendarPermissionStatus = await Permission.calendar.request(); 
                            if(calendarPermissionStatus.isGranted){
                              Navigations.goToScreen(context, Home());
                            }
                            
                          }
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        Navigations.goToScreen(context, Home());
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: CustomTextView(
                          text: "or Skip for now",
                          showUnderline: true,
                          bold: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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