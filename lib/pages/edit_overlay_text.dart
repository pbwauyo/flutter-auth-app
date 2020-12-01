import 'package:auth_app/getxcontrollers/edit_image_controller.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/dot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

final textColors = [
  Colors.red, Colors.greenAccent, Colors.amber, Colors.amberAccent, 
  Colors.blueAccent, Colors.yellowAccent, Colors.brown, Colors.cyan, Colors.cyanAccent, Colors.deepOrangeAccent, 
  Colors.deepPurpleAccent, Colors.limeAccent, Colors.indigoAccent, Colors.tealAccent, Colors.teal, Colors.pink
];

class EditOverlayText extends StatefulWidget {
  @override
  _EditOverlayTextState createState() => _EditOverlayTextState();
}

class _EditOverlayTextState extends State<EditOverlayText> {
  TextEditingController textController;
  FocusNode focusNode;
  EditImageController _editImageController = Get.find();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    focusNode = FocusNode();
    focusNode.requestFocus();

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
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: ListView(
        children: [
          Center(
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Container(
                //   child: SvgPicture.asset(AssetNames.COLOR_PALLETE_SVG,
                //     height: 30,
                //     width: 30,
                //     fit: BoxFit.cover,
                //   ),
                // ),

                Container(
                  // margin: const EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: CustomTextView(
                      text: "Done",
                      textColor: Colors.white,
                      fontSize: 18,
                      bold: true,
                    ),
                  ),
                )
              ],
            ),
          ),

          Center(
            child: Obx((){
              return Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 35, bottom: 35),
                child: CustomInputField(
                  placeholder: "", 
                  controller: textController,
                  focusNode: focusNode,
                  textColor: _editImageController.textColor.value,
                ),
              );
            }),
          ),

          Center(
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
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}