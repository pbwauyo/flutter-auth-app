import 'dart:io';
import 'dart:typed_data';

import 'package:auth_app/pages/gallery_images_grid_view.dart';
import 'package:auth_app/pages/preview_image.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:auth_app/widgets/gallery_bar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show basename, join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photofilters/photofilters.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:image/image.dart' as imageLib;

class ChangeProfilePic extends StatefulWidget {
  final List<CameraDescription> cameras;

  ChangeProfilePic({@required this.cameras});

  @override
  _ChangeProfilePicState createState() => _ChangeProfilePicState();
}

class _ChangeProfilePicState extends State<ChangeProfilePic> {
  CameraController _cameraController;
  Future<void> _initialiseControllerFuture;
  final double _buttonSize = 80;
  CameraDescription _currentDescription;

  @override
  void initState() {
    super.initState();
    _currentDescription = widget.cameras.first;
    _cameraController = CameraController(_currentDescription, ResolutionPreset.medium);
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
                    GalleryBar(),
                    GestureDetector(
                      onTap: () async{
                        try{
                          await _initialiseControllerFuture;
                          final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
                          await _cameraController.takePicture(path);

                          final file = File(path);
                          final fileName = basename(path);
                          var image = imageLib.decodeImage(file.readAsBytesSync());
                          image = imageLib.copyResize(image, width: 600);

                          Map resultMap = await Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => PhotoFilterSelector(
                                  title: Text("Filter Photo"),
                                  image: image,
                                  filters: presetFiltersList,
                                  filename: fileName,
                                  loader: Center(child: CircularProgressIndicator()),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                            if(resultMap != null){
                              if(resultMap.containsKey('image_filtered')){
                                Provider.of<FilePathProvider>(context, listen: false).filePath = (resultMap["image_filtered"] as File).path;
                              }else {
                                Provider.of<FilePathProvider>(context, listen: false).filePath = path;
                              }
                            }
                          Navigator.pop(context);
                        }catch(error){
                          print("CAMERA ERROR: $error");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                          ),

                          Column(
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

                          GestureDetector(
                            onTap: (){
                              if(_currentDescription == widget.cameras.first){
                                setState(() {
                                  _currentDescription = widget.cameras.last;
                                });
                              }else{
                                setState(() {
                                  _currentDescription = widget.cameras.first;
                                });
                              }
                            },
                            child: Icon(
                              Icons.switch_camera, 
                              size: 32,
                              color: Colors.white,
                            ),
                          )
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

}