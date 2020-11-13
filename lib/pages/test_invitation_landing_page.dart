import 'package:auth_app/pages/test_invitation_signup.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestInvitationLandingPage extends StatelessWidget {
  final invitationCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextView(
                  text: "Have an invite code?"
                ),
                
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(left: 6, right: 6, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          placeholder: "XXXX-XXXX", 
                          controller: invitationCodeController,
                          drawUnderlineBorder: false,
                        )
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: CustomTextView(
                          text: "PASTE",
                          textColor: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedRaisedButton(
                        bgColor: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                        text: "No invite?", 
                        onTap: (){
                          Navigations.goToScreen(context, TestInvitationSignUp());
                        }
                      ),

                      RoundedRaisedButton(
                        bgColor: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                        text: "Sign in", 
                        onTap: (){

                        }
                      )
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextView(
                        text: "By continuing you agree to the"
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Terms of Service",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                            TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                          ]
                        )
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}