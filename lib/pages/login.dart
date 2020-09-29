import 'package:auth_app/cubit/login_cubit.dart';
import 'package:auth_app/pages/email_login.dart';
import 'package:auth_app/pages/email_signup.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _loginCubit = context.bloc<LoginCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.blueAccent,
              margin: const EdgeInsets.only(bottom: 10),
              child: AuthButton(
                text: "Login with facebook", 
                icon: SvgPicture.asset(
                  AssetNames.FACEBOOK_LOGO_SVG,
                  height: 24,
                  width: 24,
                  color: Colors.white,
                ), 
                onTap: () async{
                  final appUser = await _loginCubit.startFacebookLogin();
                  if(appUser != null){
                    Navigations.goToScreen(context, Home());
                  }
                }
              ),
            ),

            Container(
              color: Color(0xFF00ACEE),
              margin: const EdgeInsets.only(bottom: 10),
              child: AuthButton(
                text: "Login with Twitter", 
                icon: SvgPicture.asset(
                  AssetNames.TWITTER_LOGO_SVG,
                  height: 24,
                  width: 24,
                  color: Colors.white,
                ), 
                onTap: () async{
                  final appUser = await _loginCubit.startTwitterLogin();
                  if(appUser != null){
                    Navigations.goToScreen(context, Home());
                  }
                }
              ),
            ),


            Container(
              color: Colors.black,
              margin: const EdgeInsets.only(bottom: 10),
              child: AuthButton(
                text: "Login with Google", 
                icon: SvgPicture.asset(
                  AssetNames.GOOGLE_LOGO_SVG,
                  height: 24,
                  width: 24,
                ), 
                onTap: () async{
                  final appUser = await _loginCubit.startGoogleLogin();
                  if(appUser != null){
                    Navigations.goToScreen(context, Home());
                  }
                }
              ),
            ),


            Container(
              color: Colors.black87,
              margin: const EdgeInsets.only(bottom: 20),
              child: AuthButton(
                text: "Login with email", 
                icon: Icon(Icons.email,
                  color: Colors.white,
                  size: 24,
                ), 
                onTap: (){
                  Navigations.goToScreen(context, EmailLogin());
                }
              ),
            ),

            Text("OR",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            Container(
              color: Colors.black87,
              margin: const EdgeInsets.only(bottom: 10, top: 20),
              child: AuthButton(
                text: "Signup with email", 
                icon: Icon(Icons.email,
                  color: Colors.white,
                  size: 24,
                ), 
                onTap: (){
                  Navigations.goToScreen(context, EmailSignup());
                }
              ),
            ),

          ],
        ),
      ),
    );
  }
}