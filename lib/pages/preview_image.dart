import 'dart:io';
import 'dart:typed_data';

import 'package:auth_app/cubit/signup_method_cubit.dart';
import 'package:auth_app/getxcontrollers/edit_image_controller.dart';
import 'package:auth_app/getxcontrollers/overlay_text_position_controller.dart';
import 'package:auth_app/models/memory.dart';
import 'package:auth_app/pages/edit_overlay_text.dart';
import 'package:auth_app/pages/moment_in_progress.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/moment_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/repos/moment_repo.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/custom_image_filter.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:path/path.dart' show basename, join;
import 'package:tapioca/tapioca.dart';


final filterNamesMap = {
  11 : "No filter",
  0 : "Pop",
  1 : "Amber",
  2 : "Light",
  3 : "Cool",
  4 : "Chrome",
  5 : "Film",
  6 : "Hue",
  7 : "Paris",
  8 : "Jaipur",
  9 : "Soft",
  10 : "Oslo"
};

final colorsMap = {
  11 : null,
  0 : Colors.brown,
  1 : Colors.amberAccent,
  2 : Colors.blueAccent, 
  3 : Colors.grey,
  4 : Colors.blueGrey,
  5 : Colors.tealAccent,
  6 : Colors.purpleAccent,
  7 : Colors.cyanAccent,
  8 : Colors.deepOrangeAccent,
  9 : Colors.deepPurpleAccent,
  10 : Colors.black
};

final blendModesMap = {
  11 : null,
  0 : BlendMode.colorBurn,
  1 : BlendMode.colorBurn,
  2 : BlendMode.colorDodge,
  3 : BlendMode.hardLight,
  4 : BlendMode.saturation,
  5 : BlendMode.hue,
  6 : BlendMode.dst,
  7 : BlendMode.darken,
  8 : BlendMode.hue,
  9 : BlendMode.softLight,
  10 : BlendMode.darken
};

final opacitiesMap = {
  11 : null,
  0 : 0.4,
  1 : 0.6,
  2 : 0.3,
  3 : 0.5,
  4 : 0.6,
  5 : 0.6,
  6 : 0.7,
  7 : 0.4,
  8 : 0.4,
  9 : 0.5,
  10 : 0.5
};

class PreviewImage extends StatefulWidget {
  final File imageFile;

  PreviewImage({@required this.imageFile});

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  final _momentRepo = MomentRepo();

  final _memoryRepo = MemoryRepo();

  final _globalKey = GlobalKey();

  final _userRepo = UserRepo();

  final OverlayTextPositionController _overlayTextPositionController = Get.find();
  final EditImageController _editImageController = Get.find();

  @override
  void initState() {
    super.initState();
    _overlayTextPositionController.resetPosition();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx((){
                  return RepaintBoundary(
                    key: _globalKey,
                    child: Stack(
                      children: [
                        Container(
                          child: AspectRatio(
                            aspectRatio: 3/2,
                            child: Obx((){
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(widget.imageFile),
                                    fit: BoxFit.cover,
                                    colorFilter: _updateImageColorFilter(_editImageController.selectedColorFilter.value)
                                  )
                                ),
                              );
                            }),
                          ),
                        ),
                        Positioned(
                          top: _overlayTextPositionController.top.value,
                          left: _overlayTextPositionController.left.value,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              _overlayTextPositionController.top.value += details.delta.dy;
                              _overlayTextPositionController.left.value += details.delta.dx;
                            },
                            onTap: (){
                              Navigations.showTransparentDialog(
                                context: context, 
                                screen: EditOverlayText()
                              );
                            },
                            child: Obx((){
                              return CustomTextView(
                                text: _editImageController.text.value,
                                fontSize: 18,
                                bold: true,
                                textColor: _editImageController.textColor.value,
                              );
                            }),
                          )
                        )
                      ],
                    ),
                  );
                }),

                Container(
                  alignment: Alignment.centerLeft,
                  // color: Colors.amberAccent,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 5),
                        child: CustomTextView(
                          text: "Filters",
                          textColor: Colors.white,
                          fontSize: 18,
                          bold: true,
                        ),
                      ),

                      Center(
                        child: Container(
                          height: 120,
                          alignment: Alignment.centerLeft,
                          child: Center(
                            child: ListView(
                              // padding: EdgeInsets.only(left: 16, right: 10),
                              // shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: colorsMap.entries.
                                map((colorEntry) {
                                  return Center(
                                    child: Obx((){
                                      return Container(
                                        margin: const EdgeInsets.only(right: 6),
                                        child: CustomImageFilter(
                                          isSelected: _editImageController.selectedColorFilter.value == colorEntry.key,
                                          size: 80,
                                          image: widget.imageFile, 
                                          onTap: (){
                                            print("Color: ${colorEntry.key}");
                                            _editImageController.setColorFilter(colorEntry.key);
                                          },
                                          color: colorEntry.value,
                                          opacity: opacitiesMap[colorEntry.key],
                                          blendMode: blendModesMap[colorEntry.key],
                                          filterName: filterNamesMap[colorEntry.key],
                                        ),
                                      );
                                    }),
                                  );
                                }
                              ).toList()
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ), 

          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: (){
                Navigations.showTransparentDialog(
                  context: context, 
                  screen: EditOverlayText()
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16, top: 25),
                child: CustomTextView(
                  text: "Aa",
                  textColor: Colors.white,
                  bold: true,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 16, top: 25),
                child: Icon(Icons.clear,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () async{
                    final takePictureType = Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType;
                    int count = 0;

                    if(takePictureType == MOMENT_IMAGE_EDIT){ 
                      final momentId = Provider.of<MomentIdProvider>(context, listen: false).momentid;
                      _momentRepo.updateMomentImage(momentId, widget.imageFile.path);
                      Navigator.popUntil(context, (route) {
                          return count++ == 2;
                      });

                    }else if(takePictureType == MOMENT_IMAGE_ADD){
                      final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
                      final pngBytes = await _capturePng();
                      
                      final pngFile = File(path);
                      final newFile = await pngFile.writeAsBytes(pngBytes);
                      Provider.of<FilePathProvider>(context, listen: false).filePath = newFile.path;
                      Navigator.popUntil(context, (route) {
                          return count++ == 2;
                      });
                    }else if(takePictureType == MOMENT_IMAGE_HAPPENING_NOW){
                      Provider.of<FilePathProvider>(context, listen: false).filePath = widget.imageFile.path;
                      final moment = Provider.of<MomentProvider>(context, listen: false).moment;
                      Navigator.popUntil(context, (route) {
                          return count++ == 2;
                      });
                      Navigations.goToScreen(context, MomentInProgress(moment: moment));
                    }else if(takePictureType == MEMORY_IMAGE_ADD){
                      final momentId = Provider.of<MomentIdProvider>(context, listen: false).momentid;
                      _memoryRepo.postMemory(Memory(momentId: momentId), widget.imageFile.path);
                      Navigator.popUntil(context, (route) {
                          return count++ == 2;
                      });
                    }else if(takePictureType == CHANGE_PROFILE_PIC){
                      _userRepo.updateProfilePic(imagePath: widget.imageFile.path);
                      Navigator.popUntil(context, (route) {
                          return count++ == 2;
                      });
                    }
                    else {
                      Provider.of<FilePathProvider>(context, listen: false).filePath = widget.imageFile.path;
                      Methods.showCustomSnackbar(context: context, message: "Image selected successfully");
                      final _signUpMethodCubit = context.bloc<SignupMethodCubit>();
                      if(_signUpMethodCubit.state == SignupMethodEmail()){
                        Navigator.popUntil(context, (route) => route.settings.name == "EMAIL_SIGNUP");
                      }else if(_signUpMethodCubit.state == SignupMethodPhone()){
                        Navigator.popUntil(context, (route) => route.settings.name == "PHONE_SIGNUP");
                      }
                    }     
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

  @override
  dispose(){
    _editImageController.resetImageText();
    super.dispose();
  }

  Future<Uint8List> _capturePng() async{
    RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  ColorFilter _updateImageColorFilter(int selectedColorFilter){
    return selectedColorFilter != 11 ? ColorFilter.mode(colorsMap[selectedColorFilter]
      .withOpacity(opacitiesMap[selectedColorFilter]), blendModesMap[selectedColorFilter]) : null;
  }
}