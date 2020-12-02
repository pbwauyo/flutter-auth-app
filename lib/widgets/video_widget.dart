import 'dart:io';

import 'package:auth_app/widgets/play_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:video_player/video_player.dart' as VideoPlayerPackage;

class VideoWidget extends StatefulWidget {
  final String videopath;

  VideoWidget({@required this.videopath});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  bool _isPlaying;
  bool _isLoading;
  VideoPlayerPackage.VideoPlayerController _controller;
  final spinkit = SpinKitChasingDots(
    color: Colors.black,
    size: 35.0,
  );

  @override
  void initState() {
    super.initState();

    _isPlaying = false;
    _isLoading = true;

    _getVideo();
    _addListenerToController();

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isLoading ? 
        Center(
          child: spinkit,
        ) :
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: VideoPlayerPackage.VideoPlayer(_controller),
        ),

        Align(
          alignment: Alignment.center,
          child: Visibility(
            visible: !_isPlaying,
            child: PlayButton(
              color: _isLoading ? Colors.transparent : Colors.white,
              ontap: (){
                setState(() {
                  _isLoading = true;
                  _getVideo().then(
                    (value){
                      _addListenerToController();
                      _controller.play();
                    }
                  );
                });
                
              }
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

   Future <void> _getVideo() async {
    if(widget.videopath.startsWith("http")){
      _controller = VideoPlayerPackage.VideoPlayerController.network(widget.videopath)
        ..initialize().then((_) {
          setState(() {
            _isLoading = false;
            _controller.play();
            // _controller.setLooping(true);
          });
      });
    }else{
      File fileInfo = File(widget.videopath);
      _controller = VideoPlayerPackage.VideoPlayerController.file(fileInfo)
        ..initialize().then((_) {
          setState(() {
            _isLoading = false;
            _controller.play();
            // _controller.setLooping(true);
          });
      });
    }
    
  }

  _addListenerToController(){
    _controller.addListener(() {
      print("IS VIDEO PLAYING: ${_controller.value.isPlaying}");
      if(_controller.value.isPlaying){
        setState(() {
          _isPlaying = true;
        });
      }else{
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  // bool _showPlayButton(){
  //   if(_isPlaying || _isLoading){
  //     return false;
  //   }else if(){

  //   }
  // }
}