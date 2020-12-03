import 'dart:io';

import 'package:auth_app/cubit/signup_method_cubit.dart';
import 'package:auth_app/getxcontrollers/edit_image_controller.dart';
import 'package:auth_app/getxcontrollers/overlay_text_position_controller.dart';
import 'package:auth_app/getxcontrollers/video_controller.dart';
import 'package:auth_app/models/memory.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/moment_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/repos/moment_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/text_image_filter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/instance_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tapioca/tapioca.dart';
import 'package:video_player/video_player.dart' as VideoPlayerPackage;
import 'package:get/get.dart';
import 'package:path/path.dart' show basename, join;

import 'edit_overlay_text.dart';
import 'moment_in_progress.dart';

final filterColorsList = [null, Colors.black, Colors.black54, Colors.pink, Colors.white, Colors.amber];
final filterNames = [null, 'Black', 'Light', 'Pink', 'White', 'Amber'];
const TAG = "PREVIEW_SCREEN";

class PreviewRecordedVideo extends StatefulWidget {

  PreviewRecordedVideo();

  @override
  _PreviewRecordedVideoState createState() => _PreviewRecordedVideoState();
}

class _PreviewRecordedVideoState extends State<PreviewRecordedVideo> {
  final _momentRepo = MomentRepo();

  final _memoryRepo = MemoryRepo();

  final VideoController videoController = Get.find();
  final EditImageController _editImageController = Get.find();
  final OverlayTextPositionController _overlayTextPositionController = Get.find();

  FlutterFFmpeg fFmpeg;
  VideoPlayerPackage.VideoPlayerController _controller;
  File fileInfo;
  String videoPath, originalVideoPath;
  final spinkit = SpinKitChasingDots(
    color: Colors.white,
    size: 50.0,
  );
  List<TapiocaBall> _tapiocaBalls;
  Color _selectedColor;

  @override
  void initState() {
    super.initState();

    _tapiocaBalls = [];
    
    originalVideoPath = videoController.videoPath.value; 
    videoPath = videoController.videoPath.value;

    getVideo();
    fFmpeg = new FlutterFFmpeg();
    _overlayTextPositionController.resetPosition();
    _editImageController.resetImageText();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return _controller == null ? spinkit :
     !_controller.value.initialized ? spinkit :
     Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 16, top: 25),
                  child: Icon(Icons.clear,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigations.showTransparentDialog(
                    context: context, 
                    screen: EditOverlayText()
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16, top: 25),
                  child: CustomTextView(
                    text: "Aa",
                    textColor: Colors.white,
                    bold: true,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Obx(() => Stack(
                children: [
                  Container(
                    height: _controller.value.size.height,
                    width: _controller.value.size.width,
                    child: Container(
                      child: VideoPlayerPackage.VideoPlayer(_controller),
                    ),
                  ),
                  Positioned(
                    top: _overlayTextPositionController.top.value,
                    left: _overlayTextPositionController.left.value,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        // print("$TAG DELTA Y: ${details.delta.dy} DELTA X: ${details.delta.dx}");
                        _overlayTextPositionController.top.value += details.delta.dy;
                        _overlayTextPositionController.left.value += details.delta.dx;
                      },
                      onTap: (){
                        Navigations.showTransparentDialog(
                          context: context, 
                          screen: EditOverlayText()
                        );
                      },
                      child: Obx((){
                        return CustomTextView(
                          text: _editImageController.text.value,
                          fontSize: 18,
                          bold: true,
                          textColor: _editImageController.textColor.value,
                        );
                      }),
                    )
                  )
                ],
              ),),

              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 5, left: 16),
                child: CustomTextView(
                  text: "Filters",
                  textColor: Colors.white,
                  fontSize: 18,
                  bold: true,
                ),
              ),

              Container(
                height: 90,
                margin: const EdgeInsets.only(top: 8),
                child: ListView(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  scrollDirection: Axis.horizontal,
                  children: filterColorsList.map(
                    (color) => Center(
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        child: TextImageFilter(
                          size: 80,
                          text: color == null ? "No Filter" : filterNames[filterColorsList.indexOf(color)], 
                          onTap: () async{
                            _selectedColor = color;
                            try{
                              if(color != null){
                                videoController.isFiltering.value = true;

                                final tapiocaBalls = [
                                  TapiocaBall.filterFromColor(color)
                                ];

                                var tempDir = await getTemporaryDirectory();
                                var outputPath = '${tempDir.path}/edited_video.mp4';
                                
                                final cup = Cup(Content(videoController.videoPath.value), tapiocaBalls);
                                await cup.suckUp(outputPath);
                                // videoPath = outputPath;

                                // if(_editImageController.text.value.isNotEmpty){     
                                //   final videoHeight = _controller.value.size.height;
                                //   final videoWidth = _controller.value.size.width;
                                //   final textXPosition = _overlayTextPositionController.top.value;
                                //   final textYPosition = _overlayTextPositionController.left.value;
                                //   print("$TAG VIDEO HEIGHT: $videoHeight VIDEO WIDTH: $videoWidth");
                                //   print("$TAG TEXT Y POSITION: $textYPosition TEXT X POSITION: $textXPosition");

                                //   // final x = Methods.convertToPercent(textXPosition, videoWidth, percentage: videoWidth);
                                //   // final y = Methods.convertToPercent(textYPosition, videoHeight, percentage: VIDEO_HEIGHT);
                                //   // print("$TAG X: $x Y: $y");ffffff00

                                //   try{
                                //     final newOutputPath = "${tempDir.path}/${Timestamp.now().nanoseconds}.mp4";
                                //     print("$TAG TEXT COLOR VALUE: ${Methods.colorToHexString(_editImageController.textColor.value)}");
                                //     final result = await fFmpeg.execute(Methods.encodeTextToVideoCommand(
                                //         videoPath: videoPath, 
                                //         text: _editImageController.text.value,
                                //         outputPath: newOutputPath,
                                //         top: textXPosition.toInt().toString(),
                                //         left: textYPosition.toInt().toString(),
                                //         fontColor: Methods.colorToHexString(_editImageController.textColor.value)
                                //       )
                                //     );
                                //     outputPath = newOutputPath;
                                //     print("$TAG RESULT: $result");
                                //     Methods.showCustomToast("$result");
                                //   }catch(err){
                                //     print("$TAG FFMPEG ERROR: $err");
                                //   }   
                                // }
                                
                                videoController.isFiltering.value = false;
                                setState(() {
                                  videoPath = outputPath;
                                  getVideo();
                                });
                              }else{
                                setState(() {
                                  videoPath = originalVideoPath;
                                  getVideo();
                                });
                              }
                            }catch(err){
                              print("$TAG VIDEO FILTERING ERROR: $err");
                              Methods.showGeneralErrorToast("$err");
                              videoController.isFiltering.value = false;
                            }
                          }
                        ),
                      ),
                    )
                  ).toList()
                ),
              )
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10, height: 10), //just a placeholder for alignment
              Obx(() => Container(
                margin: const EdgeInsets.only(right: 10, bottom: 10),
                child: videoController.isFiltering.value ? 
                  CustomProgressIndicator(): 
                  GestureDetector(
                    onTap: () async{
                      final takePictureType = Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType;
                      int count = 0;

                      if(takePictureType == MOMENT_IMAGE_EDIT){ 
                        final momentId = Provider.of<MomentIdProvider>(context, listen: false).momentid;
                        _momentRepo.updateMomentImage(momentId, videoPath);
                        Navigator.popUntil(context, (route) {
                            return count++ == 2;
                        });

                      }else if(takePictureType == MOMENT_IMAGE_ADD){
                        // if(_editImageController.text.value.isNotEmpty){
                        //   final videoHeight = _controller.value.size.height;
                        //   final videoWidth = _controller.value.size.width;
                        //   print("$TAG VIDEO HEIGHT: $videoHeight, VIDEO WIDTH: $videoWidth");
                        //   final textXPosition = _overlayTextPositionController.top.value;
                        //   final textYPosition = _overlayTextPositionController.left.value;
                        //   print("$TAG TEXT Y POSITION: $textYPosition TEXT X POSITION: $textXPosition");

                        //   final text = _editImageController.text.value;
                        //   final x = Methods.convertToPercent(textXPosition, videoWidth);
                        //   final y = Methods.convertToPercent(textYPosition, videoHeight);
                        //   print("$TAG X: $x Y: $y");

                        //   final size = 35;
                        //   final textColor = _editImageController.textColor.value;
                        //   _tapiocaBalls.add(TapiocaBall.textOverlay(text, x, y, size, textColor));
                        // }

                        // if(_tapiocaBalls.isNotEmpty){
                        //   var tempDir = await getTemporaryDirectory();
                        //   final outputPath = '${tempDir.path}/edited_video.mp4';
                        //   videoPath = outputPath;
                        //   final cup = Cup(Content(videoController.videoPath.value), _tapiocaBalls);
                        //   await cup.suckUp(outputPath);
                        // }

                        if(_editImageController.text.value.isNotEmpty){  
                          var tempDir = await getTemporaryDirectory();   
                          final videoHeight = _controller.value.size.height;
                          final videoWidth = _controller.value.size.width;
                          final textXPosition = _overlayTextPositionController.top.value;
                          final textYPosition = _overlayTextPositionController.left.value;
                          print("$TAG VIDEO HEIGHT: $videoHeight VIDEO WIDTH: $videoWidth");
                          print("$TAG TEXT Y POSITION: $textYPosition TEXT X POSITION: $textXPosition");

                          // final x = Methods.convertToPercent(textXPosition, videoWidth, percentage: videoWidth);
                          // final y = Methods.convertToPercent(textYPosition, videoHeight, percentage: VIDEO_HEIGHT);
                          // print("$TAG X: $x Y: $y");ffffff00

                          try{
                            final newOutputPath = "${tempDir.path}/${Timestamp.now().nanoseconds}.mp4";
                            print("$TAG TEXT COLOR VALUE: ${Methods.colorToHexString(_editImageController.textColor.value)}");
                            final result = await fFmpeg.execute(Methods.encodeTextToVideoCommand(
                                videoPath: videoPath, 
                                text: _editImageController.text.value,
                                outputPath: newOutputPath,
                                top: textXPosition.toInt().toString(),
                                left: textYPosition.toInt().toString(),
                                fontColor: Methods.colorToHexString(_editImageController.textColor.value)
                              )
                            );
                            videoPath = newOutputPath;
                            print("$TAG RESULT: $result");
                            Methods.showCustomToast("$result");
                          }catch(err){
                            print("$TAG FFMPEG ERROR: $err");
                          }   
                        }

                        Provider.of<FilePathProvider>(context, listen: false).filePath = videoPath;

                        int count = 0;
                        Navigator.popUntil(context, (route) {
                            return count++ == 2;
                        });

                      }else if(takePictureType == MOMENT_IMAGE_HAPPENING_NOW){
                        Provider.of<FilePathProvider>(context, listen: false).filePath = videoPath;
                        final moment = Provider.of<MomentProvider>(context, listen: false).moment;
                        Navigator.popUntil(context, (route) {
                            return count++ == 2;
                        });
                        Navigations.goToScreen(context, MomentInProgress(moment: moment));

                      }else if(takePictureType == MEMORY_IMAGE_ADD){
                        final momentId = Provider.of<MomentIdProvider>(context, listen: false).momentid;
                        _memoryRepo.postMemory(Memory(momentId: momentId), videoPath);
                        Navigator.popUntil(context, (route) {
                            return count++ == 2;
                        });
                      }
                      else {
                        Provider.of<FilePathProvider>(context, listen: false).filePath = videoPath;
                        Methods.showCustomSnackbar(context: context, message: "Image selected successfully");
                        final _signUpMethodCubit = context.bloc<SignupMethodCubit>();
                        if(_signUpMethodCubit.state == SignupMethodEmail()){
                          Navigator.popUntil(context, (route) => route.settings.name == "EMAIL_SIGNUP");
                        }else if(_signUpMethodCubit.state == SignupMethodPhone()){
                          Navigator.popUntil(context, (route) => route.settings.name == "PHONE_SIGNUP");
                        }
                      }  

                    },
                    child: Icon(Icons.done, 
                      size: 48,
                      color: Colors.green,
                    ),
                  ),
              ))
            ],
          ),

        ],
      )
    );
  }

  void getVideo() async {
    // final outputPath = await Methods.getVideoPath();
    // final result = await fFmpeg.execute(
    //   Methods.scaleVideoCommand(
    //     videoPath: videoPath, 
    //     outputPath: outputPath,
    //     width: MediaQuery.of(context).size.width.toString(), 
    //     height: VIDEO_HEIGHT.toString()
    //   )
    // );
    // print("$TAG SCALE RESULT: $result");
    // if(result == 0){
    //   fileInfo = File(outputPath);
    //   videoPath = outputPath;
    // }else{
    //   fileInfo = File(videoPath);
    // }
    fileInfo = File(videoPath);
    
    _controller = VideoPlayerPackage.VideoPlayerController.file(fileInfo)
      ..initialize().then((_) async{
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// if (_controller.value.isPlaying) {
//   _controller.pause();
// } else {
//   _controller.play();
// }