import 'package:auth_app/cubit/signup_cubit.dart';
import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/pages/code_verification.dart';
import 'package:auth_app/pages/congratulations.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/login.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:auth_app/utils/validators.dart';
import 'package:auth_app/widgets/custom_back_button.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailSignup extends StatefulWidget {
  final Map<String, String> profile;

  EmailSignup({this.profile});

  @override
  _EmailSignupState createState() => _EmailSignupState();
}

class _EmailSignupState extends State<EmailSignup> {
  final _usernameTxtController  = TextEditingController();

  final _passwordController = TextEditingController();

  final _nameTxtController  = TextEditingController();

  String _photoUrl;

  final _authRepo = AuthRepo();

  @override
  void initState() {
    super.initState();

    //initialise email, photoUrl and name fields incase provided through social auth
    _usernameTxtController.text = (widget.profile != null && widget.profile["email"] != "") ? widget.profile["email"] : "";
    _nameTxtController.text = (widget.profile != null && widget.profile["name"] != "") ? widget.profile["name"] : "";
    _photoUrl = (widget.profile != null && widget.profile["photoUrl"] != "") ? widget.profile["photoUrl"] : "";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: CustomBackButton(currentContext: context),
        title: CustomTextView(
          text: "Join happr",
          fontSize: 20,
          bold: true,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            if(state is SignupError){
              Methods.showFirebaseErrorToast(state.error);
            }
            else if(state is SignupSuccess){
              Methods.showCustomToast("Account created successfully");
            }
          },
          child: Stack(
            children: [
              ListView(
                children: [

                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter, 
                          end: Alignment.bottomCenter, 
                          colors: [Color(0xFFA8A8A8), Color(0xFF545454)]
                        ),
                        image: widget.profile != null && widget.profile["photoUrl"].isNotEmpty ? 
                        DecorationImage( 
                          image: NetworkImage(widget.profile["photoUrl"]),
                          fit: BoxFit.cover
                        ) : null
                      ),
                      child: widget.profile != null && widget.profile["photoUrl"].isEmpty ? 
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(AssetNames.PERSON_PNG,
                              width: 40,
                              height: 40, 
                            ),
                            CustomTextView(text: "Smile", textColor: Colors.white,)
                          ],
                        ) : Container(),
                    ),
                  ),

                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 25, top: 200),
                      child: CustomInputField(
                        textInputType: TextInputType.emailAddress,
                        placeholder: "Full name", 
                        controller: _nameTxtController,
                        drawUnderlineBorder: true,
                      ),
                    ),
                  ),

                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: CustomInputField(
                        placeholder: "Mobile number or email", 
                        controller: _usernameTxtController, 
                        drawUnderlineBorder: true,
                      ),
                    ),
                  ),

                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: CustomInputField(
                        obscureText: true,
                        placeholder: "Password", 
                        controller: _passwordController,
                        drawUnderlineBorder: true,
                      ),
                    ),
                  ),

                  Center(
                    child: Container(
                      width: screenWidth * 0.8,
                      height: 60,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 2)
                            ),
                          ),

                          Expanded(
                            child: RichText(
                              maxLines: null,
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black
                                ),
                                children: [
                                  TextSpan(
                                    text: "I have read and accept the "
                                  ),
                                  TextSpan(
                                    text: "Terms of Service", 
                                    style: TextStyle(
                                      decoration: TextDecoration.underline
                                    )
                                  )
                                ]
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: screenWidth *0.8,
                      child: BlocBuilder<SignupCubit, SignupState>(
                        builder: (context, snapshot) {
                          return RoundedRaisedButton(
                            borderRadius: 25,
                            text: "Sign up",
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            onTap: () async{

                              final username = _usernameTxtController.text.trim();
                              final password = _passwordController.text.trim();
                              final name = _nameTxtController.text.trim();

                              if(username.isNotEmpty && password.isNotEmpty && name.isNotEmpty){
                                if(Validators.isValidPhoneNumber(username)){
                                  await _authRepo.verifyUserPhoneNumber(username, context);
                                  await PrefManager.saveTemporaryUserDetails(
                                    name: name, 
                                    username: username, 
                                    password: password,
                                    photoUrl: _photoUrl
                                  );  //these will be saved later after phone verification
                                }
                                else {
                                  final appUser = AppUser(
                                    username: username,
                                    name: name,
                                    photoUrl: _photoUrl,
                                  );
                                  await context.bloc<SignupCubit>().startSignup(password, appUser);
                                  Navigations.goToScreen(context, Congratulations());
                                }
                              }
                            }, 
                          );
                        }
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
        ),
      ),
    );
  }
}