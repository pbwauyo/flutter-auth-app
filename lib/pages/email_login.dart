import 'package:auth_app/cubit/login_cubit.dart';
import 'package:auth_app/getxcontrollers/logged_in_username.dart';
import 'package:auth_app/pages/email_signup.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/phone_login.dart';
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
import 'package:get/instance_manager.dart';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  final _emailTxtController  = TextEditingController();

  final _passwordController = TextEditingController();

  final LoggedInUsernameController _loggedInUsernameController = Get.find();

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
            return BlocListener<LoginCubit, LoginState>(
              listener: (context, state){
                if(state is LoginError){
                  Methods.showCustomSnackbar(context: context, message: "${state.error}");
                }
                else if(state is LoginSuccess){
                  Methods.showCustomSnackbar(context: context, message: "Login success");
                }
              },
              child: Stack(
                children: [
                  ListView(
                    
                    children: [
                      SizedBox(
                        height: 70,
                      ),

                      Center(
                        child: CustomTextView(
                          text: "Log in with Email",
                          fontSize: 30,
                        ),
                      ),

                      Center(
                        child: Container(
                          width: screenWidth * 0.8,
                          margin: const EdgeInsets.only(bottom: 10, top: 80),
                          child: CustomInputField(
                            textInputType: TextInputType.emailAddress,
                            placeholder: "Email", 
                            drawUnderlineBorder: true,
                            prefixIcon: Icons.email,
                            controller: _emailTxtController, 
                          ),
                        ),
                      ),

                      Center(
                        child: Container(
                          width: screenWidth * 0.8,
                          margin: const EdgeInsets.only(bottom: 20, top: 25),
                          child: CustomInputField(
                            obscureText: true,
                            placeholder: "Password", 
                            controller: _passwordController,
                            prefixIcon: Icons.lock_open,
                            drawUnderlineBorder: true,
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
                                  final email = _emailTxtController.text.trim();
                                  final password = _passwordController.text.trim();

                                  if(email.isNotEmpty && password.isNotEmpty){
                                    if( !(EmailValidator.validate(email)) ){
                                      Methods.showCustomSnackbar(
                                        context: context, 
                                        message: "Invalid Email"
                                      );
                                      return;
                                    }

                                    final appUser = await _loginCubit.startFirebaseLogin(email, password);
                                    if(appUser != null){
                                      Navigations.goToScreen(context, Home());
                                    }
                                    
                                  }

                                }, 
                              );
                            }
                          ),
                        ),
                      ),

                      Center(
                        child: Container(
                          width: screenWidth * 0.8,
                          margin: const EdgeInsets.only(top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextView(
                                text: "Forgot password?",
                                showUnderline: true,
                              ),

                              CustomTextView(
                                text: "Not a happr yet?",
                                showUnderline: true,
                              )
                            ],
                          )
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
                            text: "Login with Phone instead",
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            onTap: () async{
                              Navigations.goToScreen(context, PhoneLogin());
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
              ),
            );
          }
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailTxtController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}