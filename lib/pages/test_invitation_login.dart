import 'package:auth_app/cubit/test_login_cubit.dart';
import 'package:auth_app/pages/landing_page.dart';
import 'package:auth_app/pages/test_invitation_signup.dart';
import 'package:auth_app/repos/test_invitation_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestInvitationLogin extends StatelessWidget {
  final invitationCodeController = TextEditingController();
  final emailController = TextEditingController();
  final testInvitationRepo = TestInvitationRepo();

  @override
  Widget build(BuildContext context) {
    final testLoginCubit = context.bloc<TestLoginCubit>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Colors.transparent,
      // ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.PRIMARY_COLOR, Colors.orangeAccent],
              stops: [0.6, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: ListView(
            padding: const EdgeInsets.only(left: 16, right: 16),
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: CustomTextView(
                        text: "Have an invite code?",
                        textColor: Colors.white,
                        bold: true,
                        fontSize: 25,
                      ),
                    ),

                    Container(
                      width: screenWidth * 0.9,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 6, right: 6, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: CustomInputField(
                        placeholder: "Email", 
                        controller: emailController,
                        drawUnderlineBorder: false,
                        textInputType: TextInputType.emailAddress,
                      )
                    ),
                    
                    Container(
                      width: screenWidth * 0.9,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 6, right: 6, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Builder(
                        builder: (newContext) {
                          return Row(
                            children: [
                              Expanded(
                                child: CustomInputField(
                                  placeholder: "XXXXXXXX", 
                                  controller: invitationCodeController,
                                  drawUnderlineBorder: false,
                                  textInputType: TextInputType.number,
                                )
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: FlatButton(
                                  // padding: const EdgeInsets.only(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  onPressed: () async{
                                    final clipboardValue = (await FlutterClipboard.paste()).trim();
                                    if(testInvitationRepo.verifyInvitationCodeWithOutHyphene(clipboardValue)){
                                      invitationCodeController.text = clipboardValue;
                                    }
                                    else{
                                      Methods.showCustomSnackbar(
                                        context: newContext, 
                                        message: "Invalid invitation code"
                                      );
                                    }       
                                  },
                                  color: Colors.white,
                                  child: CustomTextView(
                                    text: "PASTE",
                                    textColor: Colors.orangeAccent,
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RoundedRaisedButton(
                            bgColor: Colors.white.withOpacity(0.5),
                            text: "No invite?", 
                            textColor: Colors.white,
                            onTap: (){
                              Navigations.goToScreen(context, TestInvitationSignUp());
                            }
                          ),

                          Builder(
                            builder: (newContext) {
                              return BlocBuilder<TestLoginCubit, TestLoginState>(
                                builder: (context, state) {
                                  return RoundedRaisedButton(
                                    textColor: Colors.white,
                                    showProgress: state is TestLoginInProgress,
                                    bgColor: Colors.white.withOpacity(0.5),
                                    text: "Sign in", 
                                    onTap: () async{
                                      final email = emailController.text.trim();
                                      final invitationCode = invitationCodeController.text.trim();
                                      try{
                                        await testLoginCubit.loginTester(email: email, invitationCode: invitationCode);
                                        Navigations.goToScreen(context, LandingPage());
                                      }catch(error){
                                        print('ERROR WHILE LOGGING IN TESTER: $error');
                                        Methods.showCustomSnackbar(
                                          context: newContext, 
                                          message: "$error"
                                        );
                                      }
                                    }
                                  );
                                },
                              );
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
                            text: "By continuing you agree to the",
                            textColor: Colors.white,
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.white),
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
        ),
      ),
    );
  }
}