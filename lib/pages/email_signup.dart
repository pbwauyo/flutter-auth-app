import 'dart:io';

import 'package:auth_app/cubit/login_cubit.dart';
import 'package:auth_app/cubit/signup_cubit.dart';
import 'package:auth_app/cubit/signup_method_cubit.dart';
import 'package:auth_app/cubit/t_and_cs_cubit.dart';
import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/pages/change_profile_pic.dart';
import 'package:auth_app/pages/code_verification.dart';
import 'package:auth_app/pages/congratulations.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/login.dart';
import 'package:auth_app/pages/phone_signup.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:auth_app/utils/validators.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/image_container.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:camera/camera.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class EmailSignup extends StatefulWidget {
  final Map<String, String> profile;

  EmailSignup({this.profile});

  @override
  _EmailSignupState createState() => _EmailSignupState();
}

class _EmailSignupState extends State<EmailSignup> {
  final _emailTxtController  = TextEditingController();

  final _passwordController = TextEditingController();

  final _nameTxtController  = TextEditingController();

  final _authRepo = AuthRepo();

  bool _isSocialLoggingIn;

  @override
  void initState() {
    super.initState();

    _isSocialLoggingIn = false;
    //initialise email, photoUrl and name fields incase provided through social auth
    _emailTxtController.text = (widget.profile != null && widget.profile["email"] != "") ? widget.profile["email"] : "";
    _nameTxtController.text = (widget.profile != null && widget.profile["name"] != "") ? widget.profile["name"] : "";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tAndCsCubit = context.bloc<TAndCsCubit>();
    final _loginCubit = context.bloc<LoginCubit>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.left_chevron, 
            color: Colors.black, size: 32,
          ),
        ),
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
                        child: GestureDetector(
                          onTap: () async{
                            final cameras = await availableCameras();
                            final permissionRequestStatus = await Permission.photos.request(); //this will help in showing the gallery images
                            if(permissionRequestStatus == PermissionStatus.granted){
                              Navigations.goToScreen(context, ChangeProfilePic(cameras: cameras));
                            }else{
                              Methods.showCustomSnackbar(context: context, message: "Please allow access to photos to continue");
                            }     
                          },
                          child: Consumer<FilePathProvider>(
                            builder: (_, filePathProvider, child) {
                              final imagePath = filePathProvider.filePath;
                              
                              return Container(
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
                                child: imagePath == null || imagePath.isEmpty? 
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
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                        image: imagePath.startsWith("http") ?
                                          NetworkImage(imagePath) :
                                          FileImage(File(imagePath)),
                                          fit: BoxFit.cover
                                      )
                                    ),
                                  ),
                              );
                            }
                          ),
                        ),
                      ),

                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 25, top: 100),
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
                            placeholder: "Email", 
                            controller: _emailTxtController, 
                            drawUnderlineBorder: true,
                            textInputType: TextInputType.emailAddress,
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

                      // Center(
                      //   child: Container(
                      //     width: screenWidth * 0.8,
                      //     height: 60,
                      //     child: Row(
                      //       children: [
                      //         BlocBuilder<TAndCsCubit, TAndCsState>(
                      //           builder: (context, state) {
                      //             return GestureDetector(
                      //               onTap: (){
                      //                 tAndCsCubit.toggleCheckBox();
                      //               },
                      //               child: Container(
                      //                 alignment: Alignment.center,
                      //                 margin: const EdgeInsets.only(right: 10),
                      //                 width: 32,
                      //                 height: 32,
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(16),
                      //                   border: Border.all(width: 2)
                      //                 ),
                      //                 child: state is TAndCsChecked ? 
                      //                   Icon(Icons.check, size: 28, color: AppColors.PRIMARY_COLOR,) :
                      //                   Container()
                      //               ),
                      //             );
                      //           }
                      //         ),

                      //         Expanded(
                      //           child: RichText(
                      //             maxLines: null,
                      //             text: TextSpan(
                      //               style: TextStyle(
                      //                 color: Colors.black
                      //               ),
                      //               children: [
                      //                 TextSpan(
                      //                   text: "I have read and accept the "
                      //                 ),
                      //                 TextSpan(
                      //                   text: "Terms of Service", 
                      //                   style: TextStyle(
                      //                     decoration: TextDecoration.underline
                      //                   )
                      //                 )
                      //               ]
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),

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

                                  // if(!(tAndCsCubit.state is TAndCsChecked)){
                                  //   Methods.showCustomSnackbar(
                                  //     context: context, 
                                  //     message: "Please accept the terms and conditions to continue"
                                  //   );
                                  //   return;
                                  // }

                                  final email = _emailTxtController.text.trim();
                                  final password = _passwordController.text.trim();
                                  final name = _nameTxtController.text.trim();

                                  if(email.isNotEmpty && password.isNotEmpty && name.isNotEmpty){
                                    if(!validator.mediumPassword(password)){
                                      Methods.showCustomSnackbar(
                                        context: context, 
                                        message: "Password should have at least six characters"
                                      );
                                      return;
                                    }

                                    if(EmailValidator.validate(email)){
                                      final appUser = AppUser(
                                        username: email,
                                        name: name,
                                        photoUrl: Provider.of<FilePathProvider>(context, listen: false).filePath,
                                      );
                                      final success = await context.bloc<SignupCubit>().startSignup(context, password, appUser);
                                      if(success){
                                        Navigations.goToScreen(context, Congratulations(),);
                                      }       
                                    }
                                    else{
                                      Methods.showCustomSnackbar(
                                        context: context, 
                                        message: "Please use a valid Email"
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
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Visibility(
                            visible: _isSocialLoggingIn,
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainState: true,
                            child: CustomProgressIndicator()
                          ),
                        ),
                      ),

                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: CustomTextView(
                            text: "Signup with your social account.",
                            fontSize: 18,
                            textColor: Colors.black,
                          ),
                        ),
                      ),

                      Builder(
                        builder: (context) {
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async{
                                    setState(() {
                                      _isSocialLoggingIn = true;
                                    });

                                    try{
                                      final profile = await _loginCubit.startFacebookLogin(context);
                                      await _authRepo.createUserFromSocialAccount(profile: profile, isLogin: false);
                                      Navigations.goToScreen(context, Congratulations(),);
                                    }catch(error){
                                      print("FACEBOOK LOGIN ERROR: $error");
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("$error")
                                        )
                                      );
                                      setState(() {
                                        _isSocialLoggingIn = false;
                                      });
                                    }
                                    
                                  },
                                  child: ImageContainer(
                                    assetImage: AssetNames.FACEBOOK_LOGO_NEW_PNG,
                                    size: 42,
                                  )
                                ),

                                GestureDetector(
                                  onTap: () async{
                                    setState(() {
                                      _isSocialLoggingIn = true;
                                    });

                                    try{
                                      final profile = await _loginCubit.startTwitterLogin(context);
                                      await _authRepo.createUserFromSocialAccount(profile: profile, isLogin: false);
                                      Navigations.goToScreen(context, Congratulations(),);
                                    }catch(error){
                                      print("TWIITER LOGIN ERROR: $error");
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("$error")
                                        )
                                      );

                                      setState(() {
                                        _isSocialLoggingIn = false;
                                      }); 
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 15, right: 15),
                                    child: ImageContainer(
                                      assetImage: AssetNames.TWITTER_LOGO_NEW_PNG,
                                      size: 42,
                                    )
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () async{
                                    setState(() {
                                      _isSocialLoggingIn = true;
                                    }); 

                                    try{
                                      final profile = await _loginCubit.startGoogleLogin(context);
                                      await _authRepo.createUserFromSocialAccount(profile: profile, isLogin: false);
                                      Navigations.goToScreen(context, Congratulations(),);
                                    }catch(error){
                                      print("GOOGLE LOGIN ERROR: $error");
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("$error")
                                        )
                                      );

                                      setState(() {
                                        _isSocialLoggingIn = false;
                                      }); 
                                    } 

                                  },
                                  child: ImageContainer(
                                    assetImage: AssetNames.GOOGLE_LOGO_NEW_PNG,
                                    size: 42,
                                  )
                                ),

                                FutureBuilder<bool>(
                                  future: SignInWithApple.isAvailable(),
                                  builder: (context, snapshot){
                                    if(Platform.isIOS && snapshot.hasData && snapshot.data == true){
                                      return GestureDetector(
                                        onTap: () async{
                                          setState(() {
                                            _isSocialLoggingIn = true;
                                          });

                                          try{
                                            final profile = await _loginCubit.startAppleLogin(context);
                                            await _authRepo.createUserFromSocialAccount(profile: profile, isLogin: false);
                                            Navigations.goToScreen(context, Congratulations(),);
                                          }catch(error){
                                            print("APPLE LOGIN ERROR: $error");
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("$error")
                                              )
                                            );

                                            setState(() {
                                              _isSocialLoggingIn = true;
                                            }); 
                                          }

                                        },
                                        child: Container(
                                          width: 42,
                                          height: 42,
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 15),
                                          decoration: BoxDecoration(
                                            color: AppColors.LIGHT_GREY_SHADE2,
                                            borderRadius: BorderRadius.circular(42/2),
                                          ),
                                          child: ImageContainer(
                                            assetImage: AssetNames.APPLE_LOGO_NEW_PNG,
                                            size: 24,
                                          ),
                                        )
                                      );
                                    }
                                    return Container();
                                  }
                                ),

                              ],
                            ),
                          );
                        }
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
                          margin: const EdgeInsets.only(bottom: 30),
                          child: RoundedRaisedButton(
                            borderRadius: 25,
                            text: "Signup with Phone instead",
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            onTap: () async{
                              Navigations.goToScreen(context, PhoneSignup(), routeName: "PHONE_SIGNUP");
                              context.bloc<SignupMethodCubit>().emitPhoneSignUp();
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
}