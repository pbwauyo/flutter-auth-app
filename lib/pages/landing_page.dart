import 'package:auth_app/cubit/auth_cubit.dart';
import 'package:auth_app/cubit/login_cubit.dart';
import 'package:auth_app/cubit/signup_method_cubit.dart';
import 'package:auth_app/pages/email_login.dart';
import 'package:auth_app/pages/email_signup.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/login.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/image_container.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

class LandingPage extends StatefulWidget {
  
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  bool _isSocialLoggingIn;
  final _authRepo = AuthRepo(); 

  @override
  void initState() {
    super.initState();

    _isSocialLoggingIn = false;
  }

  @override
  Widget build(BuildContext context) {
    final _loginCubit = context.bloc<LoginCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 200, bottom: 10),
                  child: SvgPicture.asset(AssetNames.APP_LOGO_SVG,
                    height: 60,
                    width: 200,
                  ),
                ),
              ),
              
              Center(
                child: CustomTextView(
                  text: "Live Consciously",
                  fontSize: 18,
                  textColor: Colors.black,
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 40, bottom: 40),
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
                  margin: const EdgeInsets.only(top: 30, bottom: 15),
                  child: CustomTextView(
                    text: "Login with your social account.",
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
                              await _authRepo.createUserFromSocialAccount(profile: profile, isLogin: true);
                              Navigations.goToScreen(context, Home(),);
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
                              await _authRepo.createUserFromSocialAccount(profile: profile, isLogin: true);
                              Navigations.goToScreen(context, Home(),);
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
                              await _authRepo.createUserFromSocialAccount(profile: profile, isLogin: true);
                              Navigations.goToScreen(context, Home(),);
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
                                    await _authRepo.createUserFromSocialAccount(profile: profile, isLogin: true);
                                    Navigations.goToScreen(context, Home(),);
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
                  margin: const EdgeInsets.only(top: 30, bottom: 15),
                  child: CustomTextView(
                    text: "OR",
                    fontSize: 20,
                    bold: true,
                  ),
                ),
              ),

              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: RoundedRaisedButton(
                    borderRadius: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    text: "Login with Email",
                    textColor: Colors.black, 
                    bgColor: Colors.white,
                    borderColor: Colors.black,
                    onTap: (){
                      Navigations.goToScreen(context, EmailLogin());
                    }
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),

              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: RoundedRaisedButton(
                    borderRadius: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical:15),
                    text: "Don't have an account yet? Sign up",
                    textColor: Colors.black, 
                    onTap: (){
                      Navigations.goToScreen(context, EmailSignup(), routeName: "EMAIL_SIGNUP");
                      context.bloc<SignupMethodCubit>().emitEmailSignUp();
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

          Positioned(
            top: 40,
            right: 15,
            child: CustomTextView(
              text: "En",
              fontSize: 20,
              bold: true,
              textColor: Colors.black,
            )
          ),
        ],
      ),
    );
  }
}