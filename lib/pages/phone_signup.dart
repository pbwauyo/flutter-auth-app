import 'dart:io';

import 'package:auth_app/cubit/signup_cubit.dart';
import 'package:auth_app/cubit/signup_method_cubit.dart';
import 'package:auth_app/cubit/t_and_cs_cubit.dart';
import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/pages/change_profile_pic.dart';
import 'package:auth_app/pages/code_verification.dart';
import 'package:auth_app/pages/congratulations.dart';
import 'package:auth_app/pages/email_signup.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/login.dart';
import 'package:auth_app/providers/file_path_provider.dart';
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
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:camera/camera.dart';

class PhoneSignup extends StatefulWidget {
  final Map<String, String> profile;

  PhoneSignup({this.profile});

  @override
  _PhoneSignupState createState() => _PhoneSignupState();
}

class _PhoneSignupState extends State<PhoneSignup> {

  final _phoneTxtController  = TextEditingController();

  final _nameTxtController  = TextEditingController();

  final _authRepo = AuthRepo();

  String _dialCode = "+92";

  @override
  void initState() {
    super.initState();

    //initialise phone, photoUrl and name fields incase provided through social auth
    _phoneTxtController.text = (widget.profile != null && widget.profile["phone"] != "") ? widget.profile["phone"] : "";
    _nameTxtController.text = (widget.profile != null && widget.profile["name"] != "") ? widget.profile["name"] : "";
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
                        child: GestureDetector(
                          onTap: () async{
                            final cameras = await availableCameras();
                            final permissionRequestStatus = await Permission.photos.request(); //this will help in showing the gallery images
                            if(permissionRequestStatus == PermissionStatus.granted){
                              Navigations.goToScreen(context, ChangeProfilePic(camera: cameras.last));
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
                          width: screenWidth * 0.8,
                          margin: const EdgeInsets.only(bottom: 10,),
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

                                  final username = _dialCode + _phoneTxtController.text.trim();
                                  final name = _nameTxtController.text.trim();

                                  if(username.isNotEmpty && name.isNotEmpty){

                                    if(Validators.validatePhoneNumber(username)){
                                      await _authRepo.verifyUserPhoneNumber(username, context);
                                      await PrefManager.saveTemporaryUserDetails(
                                        name: name, 
                                        username: username, 
                                        photoUrl: Provider.of<FilePathProvider>(context, listen: false).filePath
                                      );  //these will be saved later after phone verification
                                    }
                                    else{
                                      Methods.showCustomSnackbar(
                                        context: context, 
                                        message: "Please use a valid Phone number"
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
                          width: screenWidth * 0.8,
                          child: RoundedRaisedButton(
                            borderRadius: 25,
                            text: "Signup with Email instead",
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            onTap: () async{
                              Navigations.goToScreen(context, EmailSignup(), routeName: "EMAIL_SIGNUP");
                              context.bloc<SignupMethodCubit>().emitEmailSignUp();
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