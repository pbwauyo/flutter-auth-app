import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/pages/landing_page.dart';
import 'package:auth_app/pages/login.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:flutter/material.dart';

import 'email_signup.dart';

class Home extends StatefulWidget {
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<AppUser> _getCurrentUserDetails;
  final _authRepo =AuthRepo();

  @override
  void initState() {
    super.initState();
    _getCurrentUserDetails = _authRepo.getCurrentUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: FutureBuilder<AppUser>(
        future: _getCurrentUserDetails,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(
              child: ErrorText(error: "Error while retrieving user dtails"),
            );
          }

          else if(snapshot.hasData){
            final appUser = snapshot.data;

            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  //If the photoUrl is not empty, load the photo else show show a background color
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: appUser.photoUrl.isNotEmpty ? 
                      NetworkImage(appUser.photoUrl) : null,
                    backgroundColor: appUser.photoUrl == null ?
                      Colors.amber : null,
                  ),

                  //show user email
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 10, top: 15),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                        child: Text(appUser.username,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: screenWidth * 0.8,
                    margin: const EdgeInsets.only(top: 20),
                    child: FlatButton(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      color: Colors.amber,
                      onPressed: () async{
                        await _authRepo.logoutUser();
                        Navigations.goToScreen(context, LandingPage());
                      }, 
                      child: Text("LOG OUT",
                        style: TextStyle(color: Colors.white),
                      )
                    ),
                  )
                ],
              ),
            );
          }
          else {
            return CustomProgressIndicator(size: 24,);
          }
        }
      ),
    );
  }
}