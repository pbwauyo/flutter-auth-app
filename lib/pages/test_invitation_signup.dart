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
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: CustomTextView(
                    text: "Let's get you on the list"
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18)
                  ),
                  child: CustomInputField(
                    placeholder: "Name", 
                    controller: _nameTxtController,
                    drawUnderlineBorder: false,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18)
                  ),
                  child: CustomInputField(
                    placeholder: "Email", 
                    controller: _emailTxtController,
                    drawUnderlineBorder: false,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 8,),
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
                          drawUnderlineBorder: true,
                          controller: _phoneTxtController, 
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Builder(
                    builder: (context) {
                      return RoundedRaisedButton(
                        text: "SUBMIT", 
                        onTap: (){
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
                        }
                      );
                    }
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: CustomTextView(
                    text: "Happr is based on real names and real identity"
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