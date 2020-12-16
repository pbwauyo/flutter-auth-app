import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPassword extends StatelessWidget {
  final _emailTxtController  = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: SvgPicture.asset(AssetNames.APP_LOGO_SVG, width: 100, height: 35,),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.left_chevron, 
            color: Colors.black, size: 32,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomInputField(
              textInputType: TextInputType.emailAddress,
              placeholder: "Enter Email", 
              drawUnderlineBorder: true,
              prefixIcon: Icons.email,
              controller: _emailTxtController, 
            ),
          ),

          Builder(
            builder: (newContext) {
              return Container(
                margin: const EdgeInsets.only(top: 16),
                child: RoundedRaisedButton(
                  text: "SEND PASSWORD RESET LINK", 
                  onTap: (){
                    final email = _emailTxtController.text.trim();
                    if(email.isEmpty){
                      Methods.showCustomSnackbar(context: newContext, message: "Email can't be empty");
                    }else{
                      _firebaseAuth.sendPasswordResetEmail(email: email);
                      Methods.showCustomSnackbar(context: newContext, message: "A password reset link has been sent to email");
                    }                  
                  }
                ),
              );
            }
          )
        ],
      ),
    );
  }
}