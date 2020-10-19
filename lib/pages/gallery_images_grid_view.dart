import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:auth_app/pages/preview_image.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/empty_results_text.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rxdart/subjects.dart';

class GalleryImagesGridView extends StatefulWidget {

  @override
  _GalleryImagesGridViewState createState() => _GalleryImagesGridViewState();
}

class _GalleryImagesGridViewState extends State<GalleryImagesGridView> {
  ScrollController _scrollController;
  int _currentPage = 0;
  int _lastPage;
  List<AssetEntity> _assetEntityList = [];

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
                    final _imageFile = await _assetEntityList[index].file;
                    Navigations.goToScreen(context, PreviewImage(imageFile: _imageFile));
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