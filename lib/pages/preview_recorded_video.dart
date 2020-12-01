import 'dart:io';

import 'package:auth_app/getxcontrollers/overlay_text_position_controller.dart';
import 'package:auth_app/getxcontrollers/video_controller.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/instance_manager.dart';
import 'package:video_player/video_player.dart' as VideoPlayerPackage;
import 'package:get/get.dart';

import 'edit_overlay_text.dart';

class PreviewRecordedVideo extends StatefulWidget {
  final String path;

  PreviewRecordedVideo({@required this.path});

  @override
  _PreviewRecordedVideoState createState() => _PreviewRecordedVideoState();
}

class _PreviewRecordedVideoState extends State<PreviewRecordedVideo> {
  final VideoController videoController = Get.find();
  final OverlayTextPositionController _overlayTextPositionController = Get.find();

  FlutterFFmpeg fFmpeg;
  VideoPlayerPackage.VideoPlayerController _controller;
  File fileInfo;
  final spinkit = SpinKitChasingDots(
    color: Colors.white,
    size: 50.0,
  );

  @override
  void initState() {
    super.initState();
    
    getVideo();
    fFmpeg = new FlutterFFmpeg();
    _overlayTextPositionController.resetPosition();
  }
  
  @override
  Widget build(BuildContext context) {
    return _controller == null ? spinkit :
     !_controller.value.initialized ? spinkit :
     Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

              Container(
                margin: const EdgeInsets.only(right: 16, top: 25),
                child: CustomTextView(
                  text: "Aa",
                  textColor: Colors.white,
                  bold: true,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          Stack(
            children: [
              Container(
                child: AspectRatio(
                  aspectRatio: 3/2,
                  child: GestureDetector(
                    onTap: (){
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    },
                    child: Container(
                      child: VideoPlayerPackage.VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: _overlayTextPositionController.top.value,
                left: _overlayTextPositionController.left.value,
                child: GestureDetector(
                  onPanUpdate: (details) {
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
                      text: videoController.videoText.value,
                      fontSize: 18,
                      bold: true,
                      textColor: videoController.textColor.value,
                    );
                  }),
                )
              )
            ],
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10, height: 10), //just a placeholder for alignment
              Container(
                margin: const EdgeInsets.only(right: 10, bottom: 10),
                child: Icon(Icons.done, 
                  size: 48,
                  color: Colors.green,
                ),
              )
            ],
          ),

        ],
      )
    );
  }

  void getVideo() async {
    fileInfo = File(widget.path);
    _controller = VideoPlayerPackage.VideoPlayerController.file(fileInfo)
      ..initialize().then((_) {
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