import 'package:auth_app/cubit/signup_cubit.dart';
import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/login.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailSignup extends StatelessWidget {
  final _emailTxtController  = TextEditingController();
  final _passwordController = TextEditingController();
  final _fNameTxtController  = TextEditingController();
  final _lNameController = TextEditingController();
  final _phoneTxtController  = TextEditingController();
  final _confPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomInputField(
                    textInputType: TextInputType.emailAddress,
                    placeholder: "Email", 
                    controller: _emailTxtController, 
                    prefixIcon: Icons.email
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomInputField(
                    placeholder: "First name", 
                    controller: _fNameTxtController, 
                    prefixIcon: Icons.person
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomInputField(
                    placeholder: "Last name", 
                    controller: _lNameController, 
                    prefixIcon: Icons.person
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomInputField(
                    placeholder: "Phone", 
                    controller: _phoneTxtController, 
                    prefixIcon: Icons.phone,
                    textInputType: TextInputType.phone,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomInputField(
                    obscureText: true,
                    placeholder: "Password", 
                    controller: _passwordController,
                    prefixIcon: Icons.lock_open
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomInputField(
                    obscureText: true,
                    placeholder: "Confirm Password", 
                    controller: _confPasswordController,
                    prefixIcon: Icons.lock_open
                  ),
                ),

                Container(
                  width: screenWidth *0.8,
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    color: Colors.amber,
                    onPressed: () async{
                      final email = _emailTxtController.text.trim();
                      final password = _passwordController.text.trim();
                      final confPassword = _confPasswordController.text.trim();
                      final phone = _phoneTxtController.text.trim();
                      final lName = _lNameController.text.trim();
                      final fName = _fNameTxtController.text.trim();

                      //check if passwords dont match
                      if(password != confPassword){
                        Methods.showCustomToast("Passwords dont match");
                        return;
                      }

                      print("LName: $lName");
                      print("FName: $fName");
                      print("password: $password");
                      print("email: $email");

                      if(email.isNotEmpty && password.isNotEmpty && fName.isNotEmpty && lName.isNotEmpty){
                        final appUser = AppUser(
                          email: email,
                          phoneNumber: phone,
                          lastName: lName,
                          firstName: fName,
                          photoUrl: "",
                          username: ""
                        );
                        await context.bloc<SignupCubit>().startSignup(password, appUser);
                        Navigations.goToScreen(context, Home());
                      }

                    }, 
                    child: BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        if (state is SignupInProgress){
                          return Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()
                          );
                        }

                        return Text("Signup",
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    )
                  ),
                ),

                Container(
                  width: screenWidth *0.8,
                  margin: const EdgeInsets.only(top: 15),
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    color: Colors.amber,
                    onPressed: (){
                      Navigations.goToScreen(context, Login());
                    }, 
                    child: Text("Already have account? Login",
                      style: TextStyle(color: Colors.white),
                    )
                  ),
                )
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}