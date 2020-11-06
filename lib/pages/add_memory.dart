import 'dart:io';
import 'dart:typed_data';

import 'package:auth_app/models/memory.dart';
import 'package:auth_app/pages/gallery_images_grid_view.dart';
import 'package:auth_app/pages/preview_image.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/repos/moment_repo.dart';
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

class AddMemory extends StatefulWidget {
  final List<CameraDescription> cameras;

  AddMemory({@required this.cameras});

  @override
  _AddMemoryState createState() => _AddMemoryState();
}

class _AddMemoryState extends State<AddMemory> {
  CameraController _cameraController;
  Future<void> _initialiseControllerFuture;
  final double _buttonSize = 80;
  final _memoryRepo = MemoryRepo();
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
                          Navigations.goToScreen(context, GalleryImagesGridView(
                            addMemory: true,
                          ));
                        },
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 32,
                        ),
                      )
                    ),
                    GalleryBar(addMemory: true,),
                    GestureDetector(
                      onTap: () async{
                        try{
                          await _initialiseControllerFuture;
                          final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
                          await _cameraController.takePicture(path);
                          final momentId = Provider.of<MomentIdProvider>(context, listen: false).momentid;

                          final file = File(path);
                          final fileName = basename(path);
                          var image = imageLib.decodeImage(file.readAsBytesSync());
                          image = imageLib.copyResize(image, width: 600);

                          Map resultMap = await Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => PhotoFilterSelector(
                                  appBarColor: AppColors.PRIMARY_COLOR,
                                  title: Center(
                                    child: CustomTextView(
                                      text: "Filter Photo", 
                                      fontSize: FontSizes.APP_BAR_TITLE,
                                    ),
                                  ),
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
                                _memoryRepo.postMemory(Memory(momentId: momentId), (resultMap["image_filtered"] as File).path);
                              }else {
                                _memoryRepo.postMemory(Memory(momentId: momentId), path);
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