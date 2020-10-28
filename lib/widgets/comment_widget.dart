import 'package:auth_app/getxcontrollers/logged_in_username.dart';
import 'package:auth_app/models/comment.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/circle_profile_image.dart';
import 'package:auth_app/widgets/comment_slider.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final String artifactType;

  CommentWidget({@required this.comment, @required this.artifactType});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final LoggedInUsernameController _loggedInUsernameController = Get.find();
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    if(widget.artifactType == ARTIFACT_TYPE_MOMENT){
      if(widget.comment.commenterUsername == _loggedInUsernameController.loggedInUserEmail){
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: CustomTextView(
                    text: widget.comment.text
                  ),
                ),

                CircleProfileImage(
                  username: widget.comment.commenterUsername
                )
              ],
            ),
          ),
        );
      }else{
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              color: AppColors.LIGHT_GREY,
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleProfileImage(
                  username: widget.comment.commenterUsername
                ),

                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: CustomTextView(
                    text: widget.comment.text
                  ),
                ),

              ],
            ),
          ),
        );
      }
    }else {
      if(widget.comment.commenterUsername == _loggedInUsernameController.loggedInUserEmail){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: CustomTextView(
                        text: widget.comment.text
                      ),
                    ),

                    CircleProfileImage(
                      username: widget.comment.commenterUsername
                    )
                  ],
                ),
              ),
            ),

            CommentSlider(
              commentId: widget.comment.id,
              initialValue: widget.comment.rating,
            ) 
          ],
        );
      }else{
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.LIGHT_GREY,
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleProfileImage(
                      username: widget.comment.commenterUsername
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: CustomTextView(
                        text: widget.comment.text
                      ),
                    ),
                  ],
                ),
              ),
            ),

            CommentSlider(
              commentId: widget.comment.id,
              initialValue: widget.comment.rating,
            )
          ],
        );
      }
    }
  }
}