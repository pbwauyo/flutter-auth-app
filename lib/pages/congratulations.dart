import 'package:auth_app/pages/contacts_permission.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Congratulations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: CustomTextView(
          text: "Congratulations",
          bold: true,
          fontSize: 20,
        ),
        elevation: 0.0,
        backgroundColor: Colors.white
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  width: 120,
                  height: 120,
                  child: SvgPicture.asset(AssetNames.CONGS_SVG, width: 110, height: 110,),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: CustomTextView(
                    text: "As a happr",
                    fontSize: 18,
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                  child: CustomTextView(
                    text: "I promise to make the world a better place. One world, one community, living in harmony with happiness for all",
                    textAlign: TextAlign.center,
                  ),
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
                      text: "I promise", 
                      onTap: (){
                        Navigations.goToScreen(context, ContactsPermission());
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