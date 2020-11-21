import 'package:auth_app/pages/test_invitation_login.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TestInvitationLandingPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.PRIMARY_COLOR, Colors.orangeAccent],
            stops: [0.6, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: SvgPicture.asset(
                  AssetNames.APP_LOGO_SVG, 
                  width: 150, 
                  height: 80,
                  color: Colors.white,
                )
              ),
              CustomTextView(
                textColor: Colors.white,
                text: "Join the waiting list?",
                bold: true,
                fontSize: 25,
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: CustomTextView(
                  textColor: Colors.white,
                  fontSize: 25,
                  textAlign: TextAlign.center,
                  text: "We're growing the Happr community slowly at first. You can join the waitlist and we'll let you know when an account is ready for you."
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20),
                child: RoundedRaisedButton(
                  text: "Let me know",
                  bgColor: Colors.white.withOpacity(0.3),
                  textColor: Colors.white,
                  fontSize: 18,
                  onTap: (){
                    Navigations.goToScreen(context, TestInvitationLogin());
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}