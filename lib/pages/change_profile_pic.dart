import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ChangeProfilePic extends StatefulWidget {
  final CameraDescription camera;

  ChangeProfilePic({@required this.camera});

  @override
  _ChangeProfilePicState createState() => _ChangeProfilePicState();
}

class _ChangeProfilePicState extends State<ChangeProfilePic> {
  CameraController _cameraController;
  Future<void> _initialiseControllerFuture;
  final double _buttonSize = 80;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(widget.camera, ResolutionPreset.medium);
    _initialiseControllerFuture = _cameraController.initialize();
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
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildGalleryBar(),
                    GestureDetector(
                      onTap: () async{
                        try{
                          await _initialiseControllerFuture;
                          final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
                          Provider.of<FilePathProvider>(context, listen: false).filePath = path;
                          print('IMAGE PATH: $path');
                          await _cameraController.takePicture(path);
                          Navigator.pop(context);
                        }catch(error){
                          print("CAMERA ERROR: $error");
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: _buttonSize,
                            height: _buttonSize,
                            decoration: BoxDecoration(
                              border: Border.all(width: 3, color: Colors.white),
                              borderRadius: BorderRadius.circular(_buttonSize/2)
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: CustomTextView(
                              text: "Tap for photo", 
                              textColor: Colors.white, 
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
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
    super.dispose();
  }

  Widget _buildGalleryBar() {
    final barHeight = 90.0;
    final vertPadding = 10.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle:  90 * math.pi / 180,
          child: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 32,
          )
        ),
        Container(
          height: barHeight,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: vertPadding),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int _){
              return Container(
                margin: const EdgeInsets.only(right: 5),
                color: Colors.amberAccent,
                padding: EdgeInsets.only(right: 5.0),
                width: 70.0,
                height: barHeight - vertPadding * 2,
              );
            }
          ),
        ),
      ],
    );
  }
}