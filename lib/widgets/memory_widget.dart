import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/models/memory.dart';
import 'package:auth_app/pages/profile_page.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:auth_app/widgets/circle_profile_image.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:auth_app/widgets/video_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemoryWidget extends StatelessWidget{
  final Memory memory;
  final double width;
  final double height;
  final _userRepo = UserRepo();

  MemoryWidget({@required this.memory, this.width = 160, this.height = 160});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Stack(
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Container(
              height: height,
              width: width,
              child: !Methods.isVideo(memory.image) ? 
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(memory.image),
                      fit: BoxFit.cover
                    )
                  ),
                ) :
                VideoWidget(videopath: memory.image)
            ),
          ),

          //  FutureBuilder<ImageProvider>(
          //   future: Methods.generateNetworkImageProvider(mediaUrl: memory.image),
          //   builder: (context, snapshot) {
          //     if(snapshot.hasData){
          //       return Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10.0),
          //           image: DecorationImage(
          //             image: snapshot.data,
          //             fit: BoxFit.cover
          //           )
          //         ),
          //       );
          //     }else if(snapshot.hasError){
          //       return Center(
          //         child: ErrorText(error: "${snapshot.error}"),
          //       );
          //     }
              
          //     return Center(
          //       child: CustomProgressIndicator(),
          //     );
          //   }
          // ),

          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              child: FutureBuilder<String>(
                future: PrefManager.getLoginUsername(),
                builder: (context, usernameSnapshot) {
                  if(usernameSnapshot.hasData){
                    return StreamBuilder<DocumentSnapshot>(
                      stream: _userRepo.getUserDetailsAsStream(username: usernameSnapshot.data),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          final user = AppUser.fromMap(snapshot.data.data());
                          return CircleProfileImage(
                            username: user.photoUrl,
                            size: 30,
                            showBorder: true,
                          );
                        }
                        return Container();
                      },
                    );
                  }
                  return Container();
                },
              )
            ),
          )
        ],
      ),
    );
  }
}
 