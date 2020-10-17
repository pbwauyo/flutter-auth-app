import 'dart:io';
import 'dart:typed_data';

import 'package:auth_app/pages/gallery_images_grid_view.dart';
import 'package:auth_app/pages/preview_image.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
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
  Future<List<AssetEntity>> _loadGalleryBarImagesFuture;
  final double _buttonSize = 80;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(widget.camera, ResolutionPreset.medium);
    _initialiseControllerFuture = _cameraController.initialize();
    _loadGalleryBarImagesFuture = _loadGalleryBarImages();
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

    return FutureBuilder<List<AssetEntity>>(
      future: _loadGalleryBarImagesFuture,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final assetEntityList = snapshot.data;
          if(assetEntityList.length > 0){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle:  90 * math.pi / 180,
                  child: GestureDetector(
                    onTap: (){
                      Navigations.goToScreen(context, GalleryImagesGridView(assetEntityList: assetEntityList));
                    },
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 32,
                    ),
                  )
                ),
                Container(
                  height: barHeight,
                  child: ListView.builder(
                    itemCount: assetEntityList.length,      
                    padding: EdgeInsets.symmetric(vertical: vertPadding),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index){
                      final fileFuture = assetEntityList[index].file;
                      return Container(
                        margin: const EdgeInsets.only(right: 5),
                        padding: EdgeInsets.only(right: 5.0),
                        width: 70.0,
                        height: barHeight - vertPadding * 2,
                        child: FutureBuilder<File>(
                          future: fileFuture,
                          builder: (context, snapshot) {
                            final _imageFile = snapshot.data;
                            if(snapshot.hasData){
                              return GestureDetector(
                                onTap: (){
                                  Navigations.goToScreen(context, PreviewImage(imageFile: _imageFile));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(_imageFile),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                ),
                              );
                            }
                            return Center(child: CustomProgressIndicator(size: 20,));
                          }
                        ),
                      );
                    }
                  ),
                ),
              ],
            );
          }else{
            return Center(child: CustomTextView(text: "No images to show"));
          }
        }else if(snapshot.hasError){
          return Center(child: ErrorText(error: "${snapshot.error}"));
        }
        return CustomProgressIndicator();
      }
    );
  }

  Future<List<AssetEntity>> _loadGalleryBarImages() async{
    final permissionRequestStatus = await Permission.photos.request();

    if(permissionRequestStatus == PermissionStatus.granted){
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(hasAll: true, type: RequestType.image);
      List<AssetEntity> media = await albums[0].getAssetListPaged(0, 100);
      return media;
    }
    return [];
  }
}