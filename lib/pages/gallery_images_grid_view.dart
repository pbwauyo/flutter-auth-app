import 'dart:io';

import 'package:auth_app/pages/preview_image.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryImagesGridView extends StatelessWidget {
  final List<AssetEntity> assetEntityList;

  GalleryImagesGridView({@required this.assetEntityList});

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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5), 
        itemCount: assetEntityList.length,
        itemBuilder: (context, index){

          final fileFuture = assetEntityList[index].file;

          return FutureBuilder<File>(
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
          );
        }
      ),
    );
  }
}