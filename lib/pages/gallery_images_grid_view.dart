import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:auth_app/cubit/signup_method_cubit.dart';
import 'package:auth_app/models/memory.dart';
import 'package:auth_app/pages/moment_in_progress.dart';
import 'package:auth_app/pages/preview_image.dart';
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
import 'package:auth_app/widgets/empty_results_text.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photofilters/photofilters.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';


class GalleryImagesGridView extends StatefulWidget {
  final String momentImageIdUpdate;
  final bool addMemory;
  final bool isMomentImage;

  GalleryImagesGridView({this.momentImageIdUpdate, this.addMemory = false, this.isMomentImage = false});

  @override
  _GalleryImagesGridViewState createState() => _GalleryImagesGridViewState();
}

class _GalleryImagesGridViewState extends State<GalleryImagesGridView> {
  ScrollController _scrollController;
  int _currentPage = 0;
  int _lastPage;
  List<AssetEntity> _assetEntityList = [];
  final _momentRepo = MomentRepo();
  final _memoryRepo = MemoryRepo();

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    
    _scrollController.addListener(() {
      final maxExtent = _scrollController.position.maxScrollExtent;
      final currentPosition = _scrollController.position.pixels;
      print("CURRENT_PAGE: $_currentPage");
      if(currentPosition / maxExtent > 0.33){
        if(_currentPage != _lastPage){
          _fetchGalleryImages();
        }    
      }
     });

     _fetchGalleryImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextView(
          text: "Choose profile image", 
          textColor: Colors.white,
          fontSize: 18,
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 3, mainAxisSpacing: 3), 
        itemCount: _assetEntityList.length,
        itemBuilder: (context, index){

          final thumbnailFuture = _assetEntityList[index].thumbData;
          return FutureBuilder<Uint8List>(
            future: thumbnailFuture,
            builder: (context, snapshot) {
              final _imageThumbnail = snapshot.data;
              if(snapshot.hasData){
                return GestureDetector(
                  onTap: () async{
                    final imageFile = await _assetEntityList[index].file;
                    final fileName = basename(imageFile.path);
                    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
                    image = imageLib.copyResize(image, width: 600);
                    int count = 0;

                    final takePictureType = Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType;
                    if(widget.isMomentImage){
                      if(takePictureType == MOMENT_IMAGE_ADD){             
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
                            Provider.of<FilePathProvider>(context, listen: false).filePath = imageFile.path;
                          }
                        }
                        Navigator.popUntil(context, (route) => count++ == 2);
                      }else if(takePictureType == MOMENT_IMAGE_HAPPENING_NOW){
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
                            Provider.of<FilePathProvider>(context, listen: false).filePath = imageFile.path;
                          }
                        }
                        final moment = Provider.of<MomentProvider>(context, listen: false).moment;
                        Navigator.popUntil(context, (route) => count++ == 2);
                        Navigations.goToScreen(context, MomentInProgress(moment: moment));
                      }else{
                        _momentRepo.updateMomentImage(widget.momentImageIdUpdate, imageFile.path);
                        Navigator.popUntil(context, (route) => count++ == 2);
                      }
                    }
                    else if(widget.addMemory){
                      final momentId = Provider.of<MomentIdProvider>(context, listen: false).momentid;
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
                          _memoryRepo.postMemory(Memory(momentId: momentId), (resultMap["image_filtered"] as File).path);
                        }else {
                          _memoryRepo.postMemory(Memory(momentId: momentId), imageFile.path);
                        }
                      }
                    
                      Navigator.popUntil(context, (route) => count++ == 2);
                    }
                    else {
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
                          Provider.of<FilePathProvider>(context, listen: false).filePath = imageFile.path;
                        }
                      }
                      Navigator.popUntil(context, (route) => count++ == 2);
                    }

                    // Methods.showCustomSnackbar(context: context, message: "Image selected successfully");
                    // final _signUpMethodCubit = context.bloc<SignupMethodCubit>();
                    // if(_signUpMethodCubit.state == SignupMethodEmail()){
                    //   Navigator.popUntil(context, (route) => route.settings.name == "EMAIL_SIGNUP");
                    // }else if(_signUpMethodCubit.state == SignupMethodPhone()){
                    //   Navigator.popUntil(context, (route) => route.settings.name == "PHONE_SIGNUP");
                    // }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_imageThumbnail),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                );
              }
              return Center(
                child: CustomProgressIndicator(size: 20,)
              );
            }
          );
        }
      )
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchGalleryImages() async{
    _lastPage = _currentPage;
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(hasAll: true, type: RequestType.image);
    List<AssetEntity> galleryImages = await albums[0].getAssetListPaged(_currentPage, 100);

    setState(() {
      _assetEntityList.addAll(galleryImages);
      _currentPage++;
    });
    
  }
}