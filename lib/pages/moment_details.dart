import 'package:auth_app/cubit/home_cubit.dart';
import 'package:auth_app/models/comment.dart';
import 'package:auth_app/models/memory.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/pages/add_memory.dart';
import 'package:auth_app/pages/all_memories.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/comment_repo.dart';
import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:auth_app/widgets/comment_widget.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/empty_results_text.dart';
import 'package:auth_app/widgets/memory_widget.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:auth_app/widgets/video_widget.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'change_moment_image.dart';

class MomentDetails extends StatelessWidget {
  final Moment moment;
  final bool isVideo;
  final _memoryRepo = MemoryRepo();
  final _commentRepo = CommentRepo();

  MomentDetails({@required this.moment, this.isVideo = false});

  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final homeCubit = context.bloc<HomeCubit>();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 15),
            children: [
              Container(
                height: 160,
                width: double.infinity,
                child: !Methods.isVideo(moment.imageUrl) ? 
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      image: DecorationImage(
                        image: moment.imageUrl.isNotEmpty ? 
                          NetworkImage(moment.imageUrl) :
                          AssetImage(Constants.momentImages[moment.category]),
                        fit: BoxFit.cover
                      )
                    ),
                  ) :
                  VideoWidget(videopath: moment.imageUrl),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, top: 15),
                  child: CustomTextView(
                    fontSize: 18,
                    text: moment.title,
                    bold: true,
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: CustomTextView(
                            text: moment.location,
                            textColor: AppColors.LIGHT_GREY_TEXT,
                          ),
                        )
                      ],
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: CustomTextView(
                            text: moment.startDateTime,
                            textColor: AppColors.LIGHT_GREY_TEXT,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.person),
                        Container(
                          width: 75,
                          height: 35,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(AssetNames.STACKED_IMAGES),
                              fit: BoxFit.contain
                            )
                          ),
                        )
                      ],
                    ),

                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Icon(Icons.share,),
                    ),
                  ],
                ),
              ),

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextView(
                      text: "Memories",
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigations.goToScreen(context, AllMemories(momentId: moment.id,));
                      },
                      child: CustomTextView(
                        text: "SEE ALL",
                        showUnderline: true,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 200,
                alignment: Alignment.center,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _memoryRepo.getMomentMemoriesAsStream(momentId: moment.id),
                  builder: (context, snapshot) {
                    
                    if(snapshot.hasData){
                      final docs = snapshot.data.docs;

                      if(docs.length <= 0){
                        return Center(
                          child: EmptyResultsText(message: "No Memories yet",),
                        );
                      }

                      final memoriesList = docs.map((doc) => Memory.fromMap(doc.data())).toList();

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: memoriesList.length,
                        itemBuilder: (context, index){
                          return Center(
                            child: GestureDetector(
                              onTap: (){
                                homeCubit.goToMemoryDetailsScreen(memoriesList[index]);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                child: MemoryWidget(
                                  memory: memoriesList[index]
                                ),
                              ),
                            ),
                          );
                        }
                      );
                    }else if(snapshot.hasError){
                      return Center(
                        child: CustomTextView(text: "${snapshot.error}"),
                      );
                    }
                    return Center(
                      child: CustomProgressIndicator(),
                    );
                  }
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: RoundedRaisedButton(
                  text: "Add Memory", 
                  onTap: ()async{
                    final photosPermission = Permission.photos;
                    final cameraPermission = Permission.camera;

                    if(! await photosPermission.isGranted ){
                      await photosPermission.request();
                    }

                    if(! await cameraPermission.isGranted){
                      await cameraPermission.request();
                    }

                    if(await photosPermission.isGranted && await cameraPermission.isGranted){
                      final cameras = await availableCameras();
                      Provider.of<MomentIdProvider>(context, listen: false).momentid = moment.id;
                      Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType = MEMORY_IMAGE_ADD;
                      Navigations.goToScreen(context, AddMemory(cameras: cameras));
                    }   
                  },
                  leadingIcon: Icon(Icons.camera_alt, color: Colors.black),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextView(
                      text: "Recent Comments",
                    ),
                    CustomTextView(
                      text: "SEE ALL",
                      showUnderline: true,
                    ),
                  ],
                ),
              ),

              Container(
                height: 300,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _commentRepo.getCommentsAsStream(artifactId: moment.id),
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
                                artifactType: ARTIFACT_TYPE_MOMENT,
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
              )
            ],
          ),
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
                    artifactId: moment.id,
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
    );
  }
}