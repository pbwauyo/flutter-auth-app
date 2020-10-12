import 'package:auth_app/cubit/signup_cubit.dart';
import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/pages/congratulations.dart';
import 'package:auth_app/pages/phone_login.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:auth_app/widgets/custom_back_button.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';

class CodeVerification extends StatefulWidget {
  final String verificationId;
  final bool isLogin;
  final phoneNumber;

  CodeVerification({@required this.verificationId, @required this.phoneNumber, this.isLogin = false});

  @override
  _CodeVerificationState createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {
  final _firstDigitController = TextEditingController();

  final _secondDigitController = TextEditingController();

  final _thirdDigitController = TextEditingController();

  final _fourthDigitController = TextEditingController();

  final _fifthDigitController = TextEditingController();

  final _sixthDigitController = TextEditingController();

  Future<Map<String, String>> _userDetailsFuture;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _authRepo = AuthRepo();

  @override
  void initState() {
    super.initState();

    _userDetailsFuture = PrefManager.getTemporaryUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final _signUpCubit = context.bloc<SignupCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: CustomTextView(text: "Verify device", fontSize: 20, bold: true,),
        leading: CustomBackButton(currentContext: context),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                  child: Center(
                    child: FutureBuilder<Map<String, String>>(
                      future: _userDetailsFuture,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return CustomTextView(
                            text: "Please enter the code we just texted to ${snapshot.data['username']}",
                            textAlign: TextAlign.center,
                            fontSize: 18,
                          );
                        }else if(snapshot.hasError){
                          return Center(child: ErrorText(error: "${snapshot.error}"));
                        }
                        return Center(child: CustomProgressIndicator(size: 20,));
                      }
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  child: CustomTextView(
                    text: "Verification Code",
                    fontSize: 18,
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F2F4),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        width: 50,
                        height: 50,
                        child: CustomInputField(
                          placeholder: "", 
                          controller: _firstDigitController,
                          maxLength: 1,
                        )
                      ),

                      Container(
                        margin: const EdgeInsets.only(right: 5, left: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F2F4),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        width: 50,
                        height: 50,
                        child: CustomInputField(
                          placeholder: "", 
                          controller: _secondDigitController,
                          maxLength: 1,
                        )
                      ),

                      Container(
                        margin: const EdgeInsets.only(right: 5, left: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F2F4),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        width: 50,
                        height: 50,
                        child: CustomInputField(
                          placeholder: "", 
                          controller: _thirdDigitController,
                          maxLength: 1,
                        )
                      ),

                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F2F4),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        width: 50,
                        height: 50,
                        child: CustomInputField(
                          placeholder: "", 
                          controller: _fourthDigitController,
                          maxLength: 1,
                        )
                      ),

                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F2F4),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        width: 50,
                        height: 50,
                        child: CustomInputField(
                          placeholder: "", 
                          controller: _fifthDigitController,
                          maxLength: 1,
                        )
                      ),

                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F2F4),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        width: 50,
                        height: 50,
                        child: CustomInputField(
                          placeholder: "", 
                          controller: _sixthDigitController,
                          maxLength: 1,
                        )
                      )
                    ],
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return RoundedRaisedButton(
                          borderRadius: 25,
                          showProgress: state is SignupInProgress,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          text: "Verify device", 
                          onTap: () async{
                            final firstDigit = _firstDigitController.text.trim();
                            final secondDigit = _secondDigitController.text.trim();
                            final thirdDigit = _thirdDigitController.text.trim();
                            final fourthDigit = _fourthDigitController.text.trim();
                            final fifthDigit = _fifthDigitController.text.trim();
                            final sixthDigit = _sixthDigitController.text.trim();

                            final fullCode = "$firstDigit$secondDigit$thirdDigit$fourthDigit$fifthDigit$sixthDigit";

                            try{
                              await _signUpCubit.startPhoneSignup(verificationId: widget.verificationId, smsCode: fullCode);
                              if(widget.isLogin){
                                final exists = await _authRepo.userExists(username: widget.phoneNumber);

                                if(!exists){
                                  _firebaseAuth.signOut();
                                  Methods.showCustomSnackbar(
                                    context: context, 
                                    message: "No matching account with phone number. Please create one",
                                    actionLabel: "Ok",
                                    actionOnTap: (){
                                      Navigations.goToScreen(context, PhoneLogin());
                                    }
                                  );
                                  return;
                                }

                                Navigations.goToScreen(context, Home());
                              }
                              
                            }catch(error){
                              print("ERROR $error");
                              Methods.showCustomSnackbar(context: context, message: "$error");
                            }
                            
                          }
                        );
                      }
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: screenWidth * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        onPressed: (){

                        },
                        child: CustomTextView(
                          text: "Resend Code"
                        ),
                      ),
                      FlatButton(
                        onPressed: (){
                          
                        },
                        child: CustomTextView(
                          text: "Need help?"
                        ),
                      )
                    ],
                  ),
                ),
              )
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
        ],
      ),
    );
  }
}