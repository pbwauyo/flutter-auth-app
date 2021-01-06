import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/validators.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';

import 'change_profile_pic.dart';
import 'landing_page.dart';

class ProfilePage extends StatelessWidget {
  final String username;

  ProfilePage({@required this.username});
  final _userRepo = UserRepo();
  final _authRepo = AuthRepo();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameTxtController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: (){
            Navigations.goToScreen(context, Home());
          },
          child: SvgPicture.asset(
            AssetNames.APP_LOGO_SVG, width: 100, height: 35,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userRepo.getUserDetailsAsStream(username: username),
        builder: (context, snapshot) {
          final user = AppUser.fromMap(snapshot.data.data());
          
          if(snapshot.hasData){
            return Builder(
              builder: (newContext) {
                return ListView(
                  children: [
                    Center(
                      child: Stack(
                        // overflow: Overflow.visible,
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8, bottom: 8),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: user.photoUrl.isNotEmpty ? 
                                  NetworkImage(user.photoUrl) :
                                  AssetImage(AssetNames.PEOPLE_LARGE),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            top: 0, 
                            // right: screenWidth * 0.5,
                            child: Center(
                              child: Container(
                                // margin: const EdgeInsets.only(bottom: 6),
                                // padding: const EdgeInsets.all(6.0),
                                // color: AppColors.PRIMARY_COLOR,
                                child: GestureDetector(
                                  onTap: () async{
                                    final cameras = await availableCameras();
                                    final permissionRequestStatus = await Permission.photos.request(); //this will help in showing the gallery images
                                    if(permissionRequestStatus == PermissionStatus.granted){
                                      Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType = CHANGE_PROFILE_PIC;
                                      Navigations.goToScreen(context, ChangeProfilePic(cameras: cameras));
                                    }else{
                                      Methods.showCustomSnackbar(context: newContext, message: "Please allow access to photos to continue");
                                    }  
                                  },
                                  child: Icon(Icons.edit, color: Colors.black,),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Center(
                      child: ListTile(
                        title: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: CustomTextView(
                            text: user.name
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (context){
                                return Material(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 25, top: 15),
                                          child: CustomInputField(
                                            placeholder: "New name", 
                                            controller: _nameTxtController,
                                            drawUnderlineBorder: true,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(bottom: 25),
                                        child: FlatButton(
                                          color: AppColors.PRIMARY_COLOR,
                                          onPressed: () async{
                                            final newName = _nameTxtController.text.trim();
                                            await _userRepo.updateName(newName: newName);
                                            Methods.showCustomSnackbar(
                                                context: newContext, 
                                                message: "Name updated successfully"
                                              );
                                          }, 
                                          child: CustomTextView(text: "DONE")
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            );
                          },
                          child: Icon(Icons.edit, color: Colors.black),
                        ),
                      ),
                    ),

                    Center(
                      child: ListTile(
                        title: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          child: CustomTextView(
                            text: user.username
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (context){
                                return Material(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 25, top: 15),
                                          child: CustomInputField(
                                            placeholder: "New Username", 
                                            controller: _usernameController,
                                            drawUnderlineBorder: true,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(bottom: 25),
                                        child: FlatButton(
                                          color: AppColors.PRIMARY_COLOR,
                                          onPressed: () async{
                                            final newUsername = _usernameController.text.trim();

                                            if(Validators.validatePhoneNumber(newUsername)){
                                              _authRepo.verifyUserPhoneNumber(newUsername, context, isUpdate: true);
                                            }
                                            else{
                                              await _userRepo.updateUsername(newUsername: newUsername);
                                              Methods.showCustomSnackbar(
                                                context: newContext, 
                                                message: "Name updated successfully"
                                              );
                                            }
                                          }, 
                                          child: CustomTextView(text: "DONE")
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            );
                          },
                          child: Icon(Icons.edit, color: Colors.black),
                        ),
                      ),
                    ),

                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: FlatButton(
                          color: AppColors.PRIMARY_COLOR,
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context){
                                return Material(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 25, top: 15),
                                          child: CustomInputField(
                                            obscureText: true,
                                            placeholder: "New Password", 
                                            controller: _passwordController,
                                            drawUnderlineBorder: true,
                                          ),
                                        ),
                                      ),

                                      Center(
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 25),
                                          child: CustomInputField(
                                            obscureText: true,
                                            placeholder: "Confirm New Password", 
                                            controller: _confirmPasswordController,
                                            drawUnderlineBorder: true,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(bottom: 20),
                                        child: FlatButton(
                                          onPressed: () async{
                                            final password = _passwordController.text.trim();
                                            final confPassword = _confirmPasswordController.text.trim();

                                            if(password != confPassword){
                                              Methods.showCustomSnackbar(context: newContext, message: "Passwords dont match");
                                              return;
                                            }

                                            if(!validator.mediumPassword(password)){
                                              Methods.showCustomSnackbar(context: newContext, message: "Password should be at least 6 characters");
                                              return;
                                            }

                                            await _userRepo.updatePassword(newPassword: password);
                                            Methods.showCustomSnackbar(
                                              context: context, 
                                              message: "Password updated successfully"
                                            );
                                            Navigator.pop(context);
                                          }, 
                                          child: CustomTextView(text: "DONE")
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            );
                          }, 
                          child: CustomTextView(text: "CHANGE PASSWORD")
                        ),
                      ),
                    )
                  ],
                );
              }
            );
          }
          else{
            return Center(
              child: CustomProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}