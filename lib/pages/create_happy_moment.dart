import 'dart:math';

import 'package:auth_app/cubit/home_cubit.dart';
import 'package:auth_app/getxcontrollers/create_moment_controller.dart';
import 'package:auth_app/pages/add_moment_details.dart';
import 'package:auth_app/pages/change_moment_image.dart';
import 'package:auth_app/pages/moment_in_progress.dart';
import 'package:auth_app/providers/moment_provider.dart';
import 'package:auth_app/providers/moment_type_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_card.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CreateHappyMoment extends StatelessWidget {
  final CreateMomentController _createMomentController = Get.find();
  
  @override
  Widget build(BuildContext context) {
    final homeCubit = context.bloc<HomeCubit>();
    final randomInt = Random().nextInt(Constants.randomMoments.length);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.4;
    final imageWidth = cardWidth * 0.6;
    final fontSize = cardWidth * 0.06;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: cardWidth,
                  height: cardWidth + 70,
                  margin: const EdgeInsets.only(right: 5),
                  child: CustomCard(
                    image: AssetNames.CUSTOM_MOMENT, 
                    title: "Custom HappyMoment", 
                    body: "",
                    imageWidth: imageWidth,
                    imageHeight: imageWidth - 20,
                    fontSize: fontSize,
                    onTap: (){
                      homeCubit.goToPickCategoryScreen();
                    },
                  ),
                ),

                Container(
                  width: cardWidth,
                  height: cardWidth + 70,
                  margin: const EdgeInsets.only(left: 5),
                  child: CustomCard(
                    image: AssetNames.ONE_CLICK_MOMENT, 
                    title: "1-Click HappyMoment", 
                    body: "",
                    imageWidth: imageWidth,
                    imageHeight: imageWidth - 20,
                    fontSize: fontSize,
                    onTap: (){
                      final randomMoment = Constants.randomMoments[randomInt];
                      Provider.of<MomentTypeProvider>(context, listen: false).momentType = MOMENT_TYPE_ONE_CLICK;
                      _createMomentController.categoryName.value = randomMoment.category;
                      homeCubit.goToAddMomentDetailsScreen(moment: randomMoment);
                      
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: cardWidth,
                height: cardWidth + 70,
                margin: const EdgeInsets.only(right: 5),
                child: CustomCard(
                  image: AssetNames.HAPPENING_NOW, 
                  title: "Happening Now", 
                  body: "",
                  fontSize: fontSize,
                  imageWidth: imageWidth,
                  imageHeight: imageWidth - 20,
                  onTap: () async{
                    final cameraPermissions = Permission.camera;
                    final photosPermissions = Permission.photos;

                    if(await cameraPermissions.isGranted && await photosPermissions.isGranted){
                      Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType = MOMENT_IMAGE_HAPPENING_NOW;
                      Provider.of<MomentProvider>(context, listen: false).moment = Constants.randomMoments[randomInt];

                      final cameras = await availableCameras();
                      Navigations.goToScreen(context, ChangeMomentImage(cameras: cameras));
                    }else{
                      await cameraPermissions.request();
                      await photosPermissions.request();
                    }
 
                  },
                ),
              ),

              Container(
                width: cardWidth,
                height: cardWidth + 70,
                margin: const EdgeInsets.only(left: 5),
                child: CustomCard(
                  image: AssetNames.QR_CODE, 
                  title: "Add throughQR Code", 
                  body: "",
                  fontSize: fontSize,
                  imageWidth: imageWidth,
                  imageHeight: imageWidth - 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}