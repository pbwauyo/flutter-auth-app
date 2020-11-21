import 'package:auth_app/cubit/test_signup_cubit.dart';
import 'package:auth_app/models/tester.dart';
import 'package:auth_app/pages/test_invitation_success.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/validators.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestInvitationSignUp extends StatefulWidget {
  @override
  _TestInvitationSignUpState createState() => _TestInvitationSignUpState();
}

class _TestInvitationSignUpState extends State<TestInvitationSignUp> {
  final _nameTxtController = TextEditingController();

  final _emailTxtController = TextEditingController();

  final _phoneTxtController = TextEditingController();

  String _dialCode = "+92";

  @override
  Widget build(BuildContext context) {
    final _testSignupCubit = context.bloc<TestSignupCubit>();
    final screenWidth = MediaQuery.of(context).size.width;

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
        child: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 60),
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: CustomTextView(
                      text: "Let's get you on the list",
                      textColor: Colors.white,
                      bold: true,
                      fontSize: 20,
                    ),
                  ),

                  Container(
                    width: screenWidth * 0.9,
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: CustomInputField(
                      placeholder: "Name", 
                      controller: _nameTxtController,
                      drawUnderlineBorder: false,
                    ),
                  ),

                  Container(
                    width: screenWidth * 0.9,
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: CustomInputField(
                      placeholder: "Email", 
                      controller: _emailTxtController,
                      drawUnderlineBorder: false,
                    ),
                  ),

                  Container(
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25)
                    ),
                    margin: const EdgeInsets.only(bottom: 8, top: 15),
                    child: Row(
                      children: [
                        CountryCodePicker(
                          textStyle: TextStyle(
                            fontSize: 18
                          ),
                          showFlag: false,
                          initialSelection: _dialCode,
                          onChanged: (CountryCode countryCode){
                            _dialCode = countryCode.dialCode;
                          },
                        ),
                        Expanded(
                          child: CustomInputField(
                            textAlign: TextAlign.left,
                            textInputType: TextInputType.phone,
                            placeholder: "Phone", 
                            drawUnderlineBorder: false,
                            controller: _phoneTxtController, 
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: BlocBuilder<TestSignupCubit, TestSignupState>(
                      builder: (context, state) {
                        return Builder(
                          builder: (context) {
                            return RoundedRaisedButton(
                              showProgress: state is TestSignupInProgress,
                              text: "SUBMIT", 
                              textColor: Colors.white,
                              onTap: () async{
                                final phone = _dialCode + _phoneTxtController.text.trim();
                                final email = _emailTxtController.text.trim();
                                final name = _nameTxtController.text.trim();
    
                                if(name.isEmpty){
                                  Methods.showCustomSnackbar(context: context, message: "Name cannot be empty");
                                  return;
                                }
                                if(!Validators.validatePhoneNumber(phone)){
                                  Methods.showCustomSnackbar(context: context, message: "Invalid Phone number");
                                  return;
                                }
                                if(!EmailValidator.validate(email)){
                                  Methods.showCustomSnackbar(context: context, message: "Invalid email");
                                  return;
                                }

                                try{
                                  final tester = Tester(
                                    name: name,
                                    email: email,
                                    phone: phone
                                  );
                                  await _testSignupCubit.startSignUp(tester);
                                  Methods.showCustomSnackbar(
                                    context: context, 
                                    message: "You have registered "
                                  );
                                  Navigations.goToScreen(context, TestInvitationSuccess());
                                }catch(error){
                                  print("TEST SIGNUP ERROR");
                                  Methods.showCustomSnackbar(
                                    context: context, 
                                    message: "$error"
                                  );
                                }
                                
                              }
                            );
                          }
                        );
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CustomTextView(
                      text: "Happr is based on real names and real identity",
                      textColor: Colors.white,
                    ),
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}