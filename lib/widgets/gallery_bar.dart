import 'dart:typed_data';

import 'package:auth_app/pages/gallery_images_grid_view.dart';
import 'package:auth_app/pages/preview_image.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:math' as math;

import 'custom_progress_indicator.dart';

class GalleryBar extends StatefulWidget {
  @override
  _GalleryBarState createState() => _GalleryBarState();
}

class _GalleryBarState extends State<GalleryBar> {

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
    final barHeight = 90.0;
    final vertPadding = 10.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        Container(
          height: barHeight,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _assetEntityList.length,      
            padding: EdgeInsets.symmetric(vertical: vertPadding),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index){
              final thumbnailFuture = _assetEntityList[index].thumbData;
              return Container(
                margin: const EdgeInsets.only(right: 5),
                padding: EdgeInsets.only(right: 5.0),
                width: 70.0,
                height: barHeight - vertPadding * 2,
                child: FutureBuilder<Uint8List>(
                  future: thumbnailFuture,
                  builder: (context, snapshot) {
                    
                    if(snapshot.hasData){
                      final _thumbnailFile = snapshot.data;
                      return GestureDetector(
                        onTap: () async{
                          final _imageFile = await _assetEntityList[index].file;
                          Navigations.goToScreen(context, PreviewImage(imageFile: _imageFile));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_thumbnailFile),
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