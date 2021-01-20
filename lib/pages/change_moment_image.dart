import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auth_app/getxcontrollers/video_controller.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/pages/gallery_images_grid_view.dart';
import 'package:auth_app/pages/moment_in_progress.dart';
import 'package:auth_app/pages/preview_image.dart';
import 'package:auth_app/providers/camera_type_provider.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/moment_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/dot.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:auth_app/widgets/gallery_bar.dart';
import 'package:auth_app/widgets/record_button_painter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:path/path.dart' show basename, join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'edit_overlay_text.dart';

class ChangeMomentImage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String momentId;

  ChangeMomentImage({@required this.cameras, this.momentId});

  @override
  _ChangeMomentImageState createState() => _ChangeMomentImageState();
}

class _ChangeMomentImageState extends State<ChangeMomentImage> with TickerProviderStateMixin{
  CameraController _cameraController;
  Future<void> _initialiseControllerFuture;
  final double _buttonSize = 80;
  final _momentRepo = MomentRepo();
  CameraDescription _currentDescription;
  String _videoPath;
  
  double newPercentage = 0.0;
  Timer timer;
  AnimationController percentageAnimationController;
  VideoController _videoController = Get.find();

  @override
  void initState() {
    super.initState();
    _videoPath = "";
    _currentDescription = widget.cameras.first;
    _cameraController = CameraController(_currentDescription, ResolutionPreset.medium);
    _initialiseControllerFuture = _cameraController.initialize();

    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 30));

    percentageAnimationController.addListener(() {
      // _videoController.percentage.value = percentageAnimationController.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialiseControllerFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Stack(
            children: [
              Center(
                child: CameraPreview(_cameraController)
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: 32,
                    //   height: 32,
                    // ),

                    Obx(() => Visibility(
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      visible: _videoController.isRecording.value,
                      child: Container(
                        width: 65,
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        margin: const EdgeInsets.only(top: 45),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Dot(
                              color: Colors.red, 
                              size: 10,
                            ),
                            Obx(()=>CustomTextView(
                              text: "${_videoController.recordedSeconds.value.toString()}s",
                              textColor: Colors.white,
                            ))
                          ],
                        ),
                      ),
                    ),),

                    // GestureDetector(
                    //   onTap: (){
                    //     Navigations.showTransparentDialog(
                    //       context: context, 
                    //       screen: EditOverlayText(showPaint: true,)
                    //     );
                    //   },
                    //   child: Container(
                    //     margin: const EdgeInsets.only(right: 16, top: 25),
                    //     child: Icon(Icons.text_fields, 
                    //       size: 32,
                    //       color: Colors.white
                    //     )
                    //   ),
                    // ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Visibility(
                      visible: !_videoController.isRecording.value,
                      maintainSize: true,
                      maintainState: true,
                      maintainAnimation: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.rotate(
                            angle:  90 * math.pi / 180,
                            child: GestureDetector(
                              onTap: (){
                                Navigations.goToScreen(context, GalleryImagesGridView());
                              },
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 32,
                              ),
                            )
                          ),
                          GalleryBar(
                            momentImageIdUpdate: widget.momentId,
                          ),
                        ],
                      ),
                    ),),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                        ),

                        Obx((){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: CustomPaint(
                                  foregroundPainter: RecordButtonPainter(
                                    lineColor: Colors.black12,
                                    completeColor: Color(0xFFee5253),
                                    completePercent: _videoController.percentage.value,
                                    width: 6.0
                                  ),
                                  child: Center(
                                    child: GestureDetector(
                                      onLongPressStart: (details){
                                        _videoController.isRecording.value = true;
                                      },
                                      onLongPress: () async{
                                        Methods.startVideoRecording(_cameraController);
                                        timer = new Timer.periodic(
                                          Duration(seconds: 1),
                                          (Timer t) async{
                                            _videoController.percentage.value = newPercentage;
                                            newPercentage += 1;
                                            _videoController.recordedSeconds.value = newPercentage.toInt();

                                            if (newPercentage > 30) {
                                              _videoController.percentage.value= 0.0;
                                              newPercentage = 0.0;
                                              timer.cancel();
                                              _videoController.isRecording.value = false;
                                              final recordedVideoPath = await Methods.stopVideoRecording(_cameraController);
                                              _videoPath = recordedVideoPath;
                                              _videoController.videoPath.value = _videoPath;
                                              Methods.playVideo(context: context);
                                            }
                                            // print("TIMER: ${t.tick}");
                                            percentageAnimationController.forward(from: 0.0);
                                            print("PERCENT CONTROLLER: ${percentageAnimationController.value}");
                                          },
                                        );
                                      },
                                      onLongPressEnd: (details) async{
                                        _videoController.isRecording.value = false;
                                        _videoController.percentage.value = 0.0;
                                        newPercentage = 0.0;
                                        timer.cancel();
                                        final recordedVideoPath = await Methods.stopVideoRecording(_cameraController);
                                        _videoPath = recordedVideoPath;
                                        _videoController.videoPath.value = _videoPath;
                                        Methods.playVideo(context: context);
                                      },
                                      onTap: () async {
                                        try{
                                          await _initialiseControllerFuture;
                                          final takenPictureFile = await _cameraController.takePicture();

                                          final file = File(takenPictureFile.path);
                                          Navigations.goToScreen(context, PreviewImage(imageFile: file));
                                          
                                        }catch(error){
                                          print("CAMERA ERROR: $error");
                                        }
                                      },
                                      child: Container(
                                        width: _buttonSize,
                                        height: _buttonSize,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 3, color: Colors.white),
                                          borderRadius: BorderRadius.circular(_buttonSize/2)
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Center(
                                child: Obx(()=>Visibility(
                                  maintainSize: true,
                                  maintainState: true,
                                  maintainAnimation: true,
                                  visible: !_videoController.isRecording.value,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: CustomTextView(
                                      text: "Tap for photo, Hold for video", 
                                      textColor: Colors.white, 
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                )
                              ),

                            ],
                          );
                        }),

                        Obx(()=> Visibility(
                          visible: !_videoController.isRecording.value,
                          maintainSize: true,
                          maintainState: true,
                          maintainAnimation: true,
                          child: GestureDetector(
                            onTap: (){
                              if(_currentDescription == widget.cameras.first){
                                setState(() {
                                  _currentDescription = widget.cameras.last;
                                  _cameraController = CameraController(_currentDescription, ResolutionPreset.medium);
                                  _initialiseControllerFuture = _cameraController.initialize();
                                });
                              }else{
                                setState(() {
                                  _currentDescription = widget.cameras.first;
                                  _cameraController = CameraController(_currentDescription, ResolutionPreset.medium);
                                  _initialiseControllerFuture = _cameraController.initialize();
                                });
                              }
                            },
                            child: Icon(
                              Icons.switch_camera, 
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        }else {
          return Center(
            child: CustomProgressIndicator(),
          );
        }
      }
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    percentageAnimationController?.dispose();
    super.dispose();
  }

}