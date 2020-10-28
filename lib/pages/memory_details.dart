import 'package:auth_app/models/comment.dart';
import 'package:auth_app/models/memory.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/pages/add_memory.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/comment_repo.dart';
import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:auth_app/widgets/artifact_slider.dart';
import 'package:auth_app/widgets/comment_slider.dart';
import 'package:auth_app/widgets/comment_widget.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/empty_results_text.dart';
import 'package:auth_app/widgets/memory_widget.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'change_moment_image.dart';

class MemoryDetails extends StatefulWidget {
  final Memory memory;

  MemoryDetails({@required this.memory});

  @override
  _MemoryDetailsState createState() => _MemoryDetailsState();
}

class _MemoryDetailsState extends State<MemoryDetails> {
  final _commentRepo = CommentRepo();

  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  image: DecorationImage(
                    image:NetworkImage(widget.memory.image),
                    fit: BoxFit.cover
                  )
                ),
              ),

              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: CustomTextView(
                          text: "Made me",
                        ),
                      ),
                    ),

                    Expanded(
                      child: ArtifactSlider(
                        artifactId: widget.memory.id,
                        initialValue: widget.memory.rating,
                      )
                    ),

                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.schedule),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: CustomTextView(
                                text: "5 minutes ago",
                                textColor: AppColors.LIGHT_GREY_TEXT,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 10),
                  child: CustomTextView(
                    text: "Comments",
                    textColor: AppColors.LIGHT_GREY_TEXT,
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _commentRepo.getCommentsAsStream(artifactId: widget.memory.id),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  final docs = snapshot.data.docs;
                  if(docs.length <= 0){
                    return Center(
                      child: EmptyResultsText(message: "No comments yet",),
                    );
                  }else {
                    final commentsList = docs.map((comment) => Comment.fromMap(comment.data())).toList();
                    return ListView.builder(
                      itemCount: commentsList.length,
                      itemBuilder: (context, index){
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: CommentWidget(
                            comment: commentsList[index], 
                            artifactType: ARTIFACT_TYPE_MEMORY,
                          ),
                        );
                      }
                    );
                  }
                }else if(snapshot.hasError){
                  return Center(
                    child: CustomTextView(text: "${snapshot.error}"),
                  );
                }
                return Center(
                  child: CustomProgressIndicator(),
                );
              }
            )
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            margin: const EdgeInsets.only(bottom: 30),
            child: Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    textAlign: TextAlign.start,
                    placeholder: "Write comment", 
                    controller: _commentController,
                    drawUnderlineBorder: true,
                  ),
                ),

                RoundedRaisedButton(
                  text: "ADD", 
                  onTap: () async{
                    final _comment = Comment(
                      text: _commentController.text.trim(),
                      artifactId: widget.memory.id,
                      commenterUsername: await PrefManager.getLoginUsername()
                    );

                    _commentRepo.postComment(_comment);
                    _commentController.text = "";
                  }
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}