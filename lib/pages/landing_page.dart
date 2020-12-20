import 'package:auth_app/cubit/auth_cubit.dart';
import 'package:auth_app/cubit/login_cubit.dart';
import 'package:auth_app/cubit/signup_method_cubit.dart';
import 'package:auth_app/pages/email_login.dart';
import 'package:auth_app/pages/email_signup.dart';
import 'package:auth_app/pages/login.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LandingPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final _loginCubit = context.bloc<LoginCubit>();

    return Scaffold(
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

              SizedBox(
                height: 150,
              ),

              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: RoundedRaisedButton(
                    borderRadius: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical:15),
                    text: "Sign up",
                    textColor: Colors.black, 
                    onTap: (){
                      Navigations.goToScreen(context, EmailSignup(), routeName: "EMAIL_SIGNUP");
                      context.bloc<SignupMethodCubit>().emitEmailSignUp();
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    text: "Already have an account? Log in",
                    textColor: Colors.black, 
                    bgColor: Colors.white,
                    borderColor: Colors.black,
                    onTap: (){
                      Navigations.goToScreen(context, EmailLogin());
                    }
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: CustomTextView(
                    text: "Or sign up with your social account.",
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
                            try{
                              final profile = await _loginCubit.startFacebookLogin(context);
                              Navigations.goToScreen(context, EmailSignup(profile: profile,), routeName: "EMAIL_SIGNUP");
                              context.bloc<SignupMethodCubit>().emitEmailSignUp();
                            }catch(error){
                              print("FACEBOOK LOGIN ERROR: $error");
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("$error")
                                )
                              );
                            } 
                          },
                          child: SvgPicture.asset(AssetNames.FACEBOOK_LOGO_NEW_SVG,
                            width: 32,
                            height: 32,
                            color: Color(0xFF1461AD),
                          ),
                        ),

                        GestureDetector(
                          onTap: () async{
                            try{
                              final profile = await _loginCubit.startTwitterLogin(context);
                              Navigations.goToScreen(context, EmailSignup(profile: profile,), routeName: "EMAIL_SIGNUP");
                              context.bloc<SignupMethodCubit>().emitEmailSignUp();
                            }catch(error){
                              print("TWIITER LOGIN ERROR: $error");
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("$error")
                                )
                              );
                            }    
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            child: SvgPicture.asset(AssetNames.TWITTER_LOGO_NEW_SVG,
                              width: 32,
                              height: 32,
                              color:  Color(0xFF0080E3),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () async{
                            try{
                              final profile = await _loginCubit.startGoogleLogin(context);
                              Navigations.goToScreen(context, EmailSignup(profile: profile,), routeName: "EMAIL_SIGNUP");
                              context.bloc<SignupMethodCubit>().emitEmailSignUp();
                            }catch(error){
                              print("GOOGLE LOGIN ERROR: $error");
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("$error")
                                )
                              );
                            } 
                          },
                          child: SvgPicture.asset(AssetNames.GOOGLE_LOGO_NEW_SVG,
                            width: 32,
                            height: 32,
                            color:  Color(0xFFD54545),
                          ),
                        ),
                      ],
                    ),
                  );
                }
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