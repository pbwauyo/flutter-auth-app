import 'package:auth_app/cubit/auth_cubit.dart';
import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/pages/landing_page.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomNavigationDrawer extends StatefulWidget {
  @override
  _CustomNavigationDrawerState createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {

  Future<AppUser> _getCurrentUserFuture;
  final _userRepo = UserRepo();
  final _authRepo = AuthRepo();


  @override
  void initState() {
    super.initState();
    _getCurrentUserFuture = _userRepo.getCurrentUserDetails();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<AppUser>(
      future: _getCurrentUserFuture,
      builder: (context, snapshot) {
        return Drawer(
          child: FutureBuilder<AppUser>(
            future: _getCurrentUserFuture,
            builder: (context, snapshot) {

              if(snapshot.hasData){
                final user = snapshot.data;
                return Column(
                  children: [
                    DrawerHeader(
                      child: Center(
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
                    ),

                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: CustomTextView(
                          text: user.name
                        ),
                      ),
                    ),

                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: CustomTextView(
                          text: user.username
                        ),
                      ),
                    ),

                    Center(
                      child: FlatButton(
                        color: AppColors.PRIMARY_COLOR,
                        onPressed: (){
                          _authRepo.logoutUser();
                          Navigations.goToScreen(context, LandingPage(), withReplacement: true);
                        }, 
                        child: CustomTextView(text: "LOGOUT")
                      ),
                    )
                  ],
                );
              }

              else if(snapshot.hasError){
                return Center(
                  child: ErrorText(error: "${snapshot.error}"),
                );
              }
              return Center(
                child: CustomProgressIndicator(),
              );         
            }
          )
        );
      }
    );
  }
}