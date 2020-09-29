import 'package:auth_app/cubit/login_cubit.dart';
import 'package:auth_app/pages/email_signup.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailLogin extends StatelessWidget {
  final _emailTxtController  = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final _loginCubit = context.bloc<LoginCubit>();


    return Scaffold(
      body: SafeArea(
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state){
            if(state is LoginError){
              Methods.showFirebaseErrorToast(state.error);
            }
            else if(state is LoginSuccess){
              Methods.showCustomToast("Login success");
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
                  width: screenWidth * 0.8,
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    color: Colors.amber,
                    onPressed: () async{
                      final email = _emailTxtController.text.trim();
                      final password = _passwordController.text.trim();

                      if(email.isNotEmpty && password.isNotEmpty){
                        final appUser = await _loginCubit.startFirebaseLogin(email, password);
                        if(appUser != null){
                          Navigations.goToScreen(context, Home());
                        }
                        
                      }

                    }, 
                    child:  BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state is LoginInProgress){
                          return Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()
                          );
                        }

                        return Text("Login",
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    )
                  ),
                ),

                Container(
                  width: screenWidth * 0.8,
                  margin: const EdgeInsets.only(top: 15),
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    color: Colors.amber,
                    onPressed: (){
                      Navigations.goToScreen(context, EmailSignup());
                    }, 
                    child: Text("No account yet? Signup",
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