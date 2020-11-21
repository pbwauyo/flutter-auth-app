import 'package:auth_app/pages/landing_page.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestInvitationSuccess extends StatelessWidget {
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
              CustomTextView(
                text: "You're on the list!",
                bold: true,
                fontSize: 25,
                textColor: Colors.white,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: CustomTextView(
                  text: "Thanks for joining the waiting list. We'll let you know as soon as your account is ready.",
                  textColor: Colors.white,
                  fontSize: 25,
                  textAlign: TextAlign.center,
                ),
              ),

              // Container(
              //   margin: const EdgeInsets.only(top: 10),
              //   child: RoundedRaisedButton(
              //     text: "CONTINUE", 
              //     onTap: (){
              //       Navigations.goToScreen(context, LandingPage());
              //     }
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}