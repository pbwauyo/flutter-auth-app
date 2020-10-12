import 'package:auth_app/cubit/login_cubit.dart';
import 'package:auth_app/pages/email_login.dart';
import 'package:auth_app/pages/email_signup.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/validators.dart';
import 'package:auth_app/widgets/custom_back_button.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:country_code_picker/country_code_picker.dart';


class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final _phoneTxtController  = TextEditingController();

  final _authRepo = AuthRepo();
  String _dialCode = "+92";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final _loginCubit = context.bloc<LoginCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: SvgPicture.asset(AssetNames.APP_LOGO_SVG, width: 100, height: 35,),
        leading: CustomBackButton(currentContext: context),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 10),
            child: CustomTextView(text: "En", bold: true, fontSize: 20,)
          )
        ],
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return Stack(
              children: [
                ListView(
                  children: [
                    SizedBox(
                      height: 70,
                    ),

                    Center(
                      child: CustomTextView(
                        text: "Log in with Phone",
                        fontSize: 30,
                      ),
                    ),

                    Center(
                      child: Container(
                        width: screenWidth * 0.8,
                        margin: const EdgeInsets.only(bottom: 10, top: 80),
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
                                showIcon: false,
                                controller: _phoneTxtController, 
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Center(
                      child: Container(
                        width: screenWidth * 0.8,
                        margin: const EdgeInsets.only(top: 40),
                        child: BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            return RoundedRaisedButton(
                              borderRadius: 25,
                              text: "Login",
                              showProgress: state is LoginInProgress,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              onTap: () async{
                                final phone = _dialCode + _phoneTxtController.text.trim();

                                if(phone.isNotEmpty){
                                  if(!(Validators.validatePhoneNumber(phone)) ){
                                    Methods.showCustomSnackbar(
                                      context: context, 
                                      message: "Invalid Phone Number"
                                    );
                                    return;
                                  }
                                  await _authRepo.verifyUserPhoneNumber(phone, context, isLogin: true);
                                }
                              }, 
                            );
                          }
                        ),
                      ),
                    ),

                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: CustomTextView(
                          text: "OR",
                          fontSize: 20,
                          bold: true,
                        )
                      ),
                    ),

                    Center(
                      child: Container(
                        width: screenWidth * 0.8,
                        child: RoundedRaisedButton(
                          borderRadius: 25,
                          text: "Login with Email instead",
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          onTap: () async {
                            Navigations.goToScreen(context, EmailLogin());
                          },
                        ),
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
                  top: 40,
                  left: 15,
                  child: Ring(
                    size: 50,
                    width: 4,
                  )
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}