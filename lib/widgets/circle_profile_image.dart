import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:flutter/material.dart';

class CircleProfileImage extends StatefulWidget {
  final double size;
  final String username;
  final bool showBorder;

  CircleProfileImage({@required this.username, this.size = 25, this.showBorder = false});

  @override
  _CircleProfileImageState createState() => _CircleProfileImageState();
}

class _CircleProfileImageState extends State<CircleProfileImage> {
  final _userRepo = UserRepo();
  Future<AppUser> _getUserDetailsFuture;

  @override
  void initState() {
    super.initState();
    _getUserDetailsFuture = _userRepo.getUserDetails(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: _getUserDetailsFuture,
      builder:(context, snapshot){
        if(snapshot.hasData){
          final appUser = snapshot.data;
          final photoUrl = appUser.photoUrl;
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size/2),
              border: widget.showBorder ? Border.all(color: Colors.white, width: 1.5) : Border.all(color: Colors.transparent),
              image: DecorationImage(
                image: photoUrl != null && photoUrl.isNotEmpty ? 
                  NetworkImage(photoUrl) :
                  AssetImage(AssetNames.DEFAULT_USER),
                  fit: BoxFit.cover
              )
            ),
          );
        }
        else if(snapshot.hasError){
          return Center(
            child: ErrorText(error: "Er"),
          );
        }
        return Center(
          child: CustomProgressIndicator(size: 20)
        );
      }
    );
  }
  
}