import 'dart:io';

import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewImage extends StatelessWidget {
  final File imageFile;

  PreviewImage({@required this.imageFile});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 3/2,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
          ), 
          Align(
            alignment: Alignment.bottomRight,
            child: Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: (){
                    Provider.of<FilePathProvider>(context, listen: false).filePath = imageFile.path;
                    Methods.showCustomSnackbar(context: context, message: "Image selected successfully");
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 10),
                    child: Icon(Icons.done, 
                      size: 48,
                      color: Colors.green,
                    ),
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}