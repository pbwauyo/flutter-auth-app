import 'package:auth_app/cubit/signup_cubit.dart';
import 'package:auth_app/cubit/t_and_cs_cubit.dart';
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
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:regexed_validator/regexed_validator.dart';

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
    final tAndCsCubit = context.bloc<TAndCsCubit>();

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
        child: Builder(
          builder: (context) {
            return BlocListener<SignupCubit, SignupState>(
              listener: (context, state) {
                if(state is SignupError){
                  Methods.showCustomSnackbar(context: context, message: "${state.error}");
                }
                else if(state is SignupSuccess){
                  Methods.showCustomSnackbar(context: context, message: "Account created successfully");
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
                          ),
                          child: widget.profile == null || widget.profile["photoUrl"].isEmpty? 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(
                                  image: AssetImage(AssetNames.PERSON_PNG),
                                  height: 40,
                                  width: 40,
                                ),
                                CustomTextView(text: "Smile", textColor: Colors.white,)
                              ],
                            ) : 
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(widget.profile["photoUrl"]),
                            ),
                        ),
                      ),

                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 25, top: 200),
                          child: CustomInputField(
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
                              BlocBuilder<TAndCsCubit, TAndCsState>(
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: (){
                                      tAndCsCubit.toggleCheckBox();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(right: 10),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(width: 2)
                                      ),
                                      child: state is TAndCsChecked ? 
                                        Icon(Icons.check, size: 28, color: AppColors.PRIMARY_COLOR,) :
                                        Container()
                                    ),
                                  );
                                }
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
                            builder: (context, state) {
                              return RoundedRaisedButton(
                                borderRadius: 25,
                                text: "Sign up",
                                showProgress: state is SignupInProgress,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                onTap: () async{

                                  if(!(tAndCsCubit.state is TAndCsChecked)){
                                    Methods.showCustomSnackbar(
                                      context: context, 
                                      message: "Please accept the terms and conditions to continue"
                                    );
                                    return;
                                  }

                                  final username = _usernameTxtController.text.trim();
                                  final password = _passwordController.text.trim();
                                  final name = _nameTxtController.text.trim();

                                  if(username.isNotEmpty && password.isNotEmpty && name.isNotEmpty){
                                    if(!validator.password(password)){
                                      // _passwordController
                                      Methods.showCustomSnackbar(
                                        context: context, 
                                        message: "Password should have at least one UPPERCASE, one lowercase, one digit and one special character"
                                      );
                                      return;
                                    }

                                    if(Validators.validatePhoneNumber(username)){
                                      await _authRepo.verifyUserPhoneNumber(username, context);
                                      await PrefManager.saveTemporaryUserDetails(
                                        name: name, 
                                        username: username, 
                                        password: password,
                                        photoUrl: _photoUrl
                                      );  //these will be saved later after phone verification
                                    }
                                    else if(EmailValidator.validate(username)){
                                      final appUser = AppUser(
                                        username: username,
                                        name: name,
                                        photoUrl: _photoUrl,
                                      );
                                      final success = await context.bloc<SignupCubit>().startSignup(password, appUser);
                                      if(success){
                                        Navigations.goToScreen(context, Congratulations());
                                      }       
                                    }
                                    else{
                                      Methods.showCustomSnackbar(
                                        context: context, 
                                        message: "Please use a valid Phone number or Email"
                                      );
                                    }
                                  }
                                  else {
                                    Methods.showCustomSnackbar(
                                      context: context, 
                                      message: "Please fill in all fields"
                                    );
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
            );
          }
        ),
      ),
    );
  }
}