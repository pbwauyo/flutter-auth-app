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
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextView(
              text: "You're on the list!",
              bold: true,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: CustomTextView(
                text: "Thanks for joining the list."
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 10),
              child: RoundedRaisedButton(
                text: "CONTINUE", 
                onTap: (){
                  Navigations.goToScreen(context, LandingPage());
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}