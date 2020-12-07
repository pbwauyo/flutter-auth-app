import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:auth_app/getxcontrollers/edit_image_controller.dart';
import 'package:auth_app/models/memory.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/moment_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/repos/moment_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/dot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'dart:ui' as ui;
import 'package:path/path.dart' show basename, join;
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';

import 'moment_in_progress.dart';


final textColors = [
  Colors.white, Colors.red, Colors.greenAccent, Colors.amber, Colors.amberAccent, 
  Colors.blueAccent, Colors.yellowAccent, Colors.brown, Colors.cyan, Colors.cyanAccent, Colors.deepOrangeAccent, 
  Colors.deepPurpleAccent, Colors.limeAccent, Colors.indigoAccent, Colors.tealAccent, Colors.teal, Colors.pink
];

final backgroundColors = [
  Colors.transparent, Colors.white, Colors.indigoAccent, Colors.greenAccent, Colors.cyanAccent, Colors.amberAccent,
];

class EditOverlayText extends StatefulWidget {
  final bool showPaint;

  EditOverlayText({this.showPaint = false});

  @override
  _EditOverlayTextState createState() => _EditOverlayTextState();
}

class _EditOverlayTextState extends State<EditOverlayText> {
  TextEditingController textController;
  FocusNode focusNode;
  EditImageController _editImageController = Get.find();
  Color backgroundColor;
  final _globalKey = GlobalKey();
  final _momentRepo = MomentRepo();

  final _memoryRepo = MemoryRepo();


  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    focusNode = FocusNode();
    backgroundColor = Colors.transparent;
    focusNode.requestFocus();

    focusNode.addListener(() {
      _editImageController.hasFocus.value = focusNode.hasFocus;
    });

    // Future.delayed(Duration.zero, (){
    //   focusNode.addListener(() {
    //     if(!focusNode.hasFocus){
    //       Navigator.pop(context);
    //     }
    //   });
    // });

    textController.text = _editImageController.text.value; //initialise the textinput field with the getx controller text

    textController.addListener(() {
      _editImageController.text.value = textController.text.trim();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: (){
        if(focusNode.hasFocus){
          focusNode.unfocus();
        }
      },
      child: RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: backgroundColor,
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            child: ListView(
              children: [
                Center(
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      Visibility(
                        visible: widget.showPaint,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              backgroundColor = _getRandomBackgroundColor(backgroundColors.length);
                            });
                          },
                          child: Container(
                            child: SvgPicture.asset(AssetNames.COLOR_PALLETE_SVG,
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      Container(
                        // margin: const EdgeInsets.only(left: 15),
                        child: GestureDetector(
                          onTap: () async{
                            final takePictureType = Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType;
                            int count = 0;
                            final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");

                            if(widget.showPaint){
                              if(takePictureType == MOMENT_IMAGE_ADD){
                                
                                final pngBytes = await _capturePng();    
                                final pngFile = File(path);
                                await pngFile.writeAsBytes(pngBytes);

                                Provider.of<FilePathProvider>(context, listen: false).filePath = path;
                                Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                });
                              }else if(takePictureType == MEMORY_IMAGE_ADD){
                                final pngBytes = await _capturePng();    
                                final pngFile = File(path);
                                await pngFile.writeAsBytes(pngBytes);

                                final momentId = Provider.of<MomentIdProvider>(context, listen: false).momentid;
                                _memoryRepo.postMemory(Memory(momentId: momentId), path);
                                Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                });
                              }
                            }else{
                              Navigator.pop(context);
                            }
                            
                          },
                          child: CustomTextView(
                            text: "Done",
                            textColor: backgroundColor == Colors.white ? Colors.black : Colors.white,
                            fontSize: 18,
                            bold: true,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: screenHeight/4),
                  child: Obx((){
                    return Container(
                      margin: const EdgeInsets.only(left: 16, right: 16, top: 35, bottom: 35),
                      child: CustomInputField(
                        placeholder: "Enter text here", 
                        controller: textController,
                        focusNode: focusNode,
                        textColor: _editImageController.textColor.value,
                        drawUnderlineBorder: true,
                      ),
                    );
                  }),
                ),

                Center(
                  child: Obx(() => Visibility(
                    visible: _editImageController.hasFocus.value,
                    child: Container(
                      height: 32,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: textColors.map(
                          (color) => Center(
                            child: Dot(
                              size: 30,
                              color: color,
                              onTap: (){
                                _editImageController.textColor.value = color;
                              },
                            ),
                          )
                        ).toList()
                      ),
                    ),
                  ),)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Color _getRandomBackgroundColor(int max){
    int randomNumber = Random().nextInt(max);
    return backgroundColors[randomNumber];
  }

  Future<Uint8List> _capturePng() async{
    RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }
}