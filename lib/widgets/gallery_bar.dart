import 'dart:io';
import 'dart:typed_data';

import 'package:auth_app/models/memory.dart';
import 'package:auth_app/pages/gallery_images_grid_view.dart';
import 'package:auth_app/pages/moment_in_progress.dart';
import 'package:auth_app/pages/preview_image.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/moment_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/repos/moment_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:math' as math;
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'custom_progress_indicator.dart';

class GalleryBar extends StatefulWidget {
  final String momentImageIdUpdate;
  // final bool addMemory;
  // final bool isMomentImage;

  GalleryBar({this.momentImageIdUpdate});

  @override
  _GalleryBarState createState() => _GalleryBarState();
}

class _GalleryBarState extends State<GalleryBar> {

  ScrollController _scrollController;
  int _currentPage = 0;
  int _lastPage;
  List<AssetEntity> _assetEntityList = [];
  // final _momentRepo = MomentRepo();
  // final _memoryRepo = MemoryRepo();

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
                          final imageFile = await _assetEntityList[index].file;

                          Navigations.goToScreen(context, PreviewImage(imageFile: imageFile));
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