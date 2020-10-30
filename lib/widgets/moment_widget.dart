import 'package:auth_app/cubit/home_cubit.dart';
import 'package:auth_app/getxcontrollers/create_moment_controller.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/pages/add_memory.dart';
import 'package:auth_app/pages/change_moment_image.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/repos/moment_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MomentWidget extends StatefulWidget {
  final Moment moment;

  MomentWidget({@required this.moment});

  @override
  _MomentWidgetState createState() => _MomentWidgetState();
}

class _MomentWidgetState extends State<MomentWidget> {
  final _momentRepo = MomentRepo();
  final CreateMomentController _createMomentController = Get.find();

  var _tapPosition;

  @override
  Widget build(BuildContext context) {

    final homeCubit = context.bloc<HomeCubit>();

    return GestureDetector(
      onTap: (){
        homeCubit.goToMomentDetailsScreen(widget.moment);
      },
      onTapDown: _storePosition,
      onLongPress: (){
        final RenderBox overlay = Overlay.of(context).context.findRenderObject();
        showMenu(
          context: context, 
          position: RelativeRect.fromRect(
              _tapPosition & const Size(40, 40), // smaller rect, the touch area
              Offset.zero & overlay.size   // Bigger rect, the entire screen
          ),
          items: <PopupMenuEntry<int>>[
            PopupMenuItem(value: 1, child: CustomTextView(text: "DELETE", textColor: Colors.red,)),
            PopupMenuItem(value: 2, child: CustomTextView(text: "EDIT", textColor: Colors.orange,))
          ]
        ).then((value){
          if(value == 1){
            _momentRepo.deleteMoment(momentId: widget.moment.id);
          }
          else {
            final imageUrl = widget.moment.imageUrl;
            if(imageUrl == null || imageUrl.isEmpty){
              _createMomentController.categoryName.value = widget.moment.category;
            }
            else {
              Provider.of<FilePathProvider>(context, listen: false).filePath = imageUrl;
            }
            homeCubit.goToAddMomentDetailsScreen(moment: widget.moment);      
          }
        });
      },
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                image: DecorationImage(
                  image: widget.moment.imageUrl.isNotEmpty ? 
                    NetworkImage(widget.moment.imageUrl) :
                    AssetImage(Constants.momentImages[widget.moment.category]),
                  fit: BoxFit.cover
                )
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 20, top: 15),
                child: CustomTextView(
                  fontSize: 18,
                  text: widget.moment.title,
                  bold: true,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: CustomTextView(
                          text: widget.moment.location,
                          textColor: AppColors.LIGHT_GREY_TEXT,
                        ),
                      )
                    ],
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: CustomTextView(
                          text: widget.moment.dateTime,
                          textColor: AppColors.LIGHT_GREY_TEXT,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      Container(
                        width: 75,
                        height: 35,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AssetNames.STACKED_IMAGES),
                            fit: BoxFit.contain
                          )
                        ),
                      )
                    ],
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.LIGHT_GREY_SHADE2,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Icon(Icons.share),
                      ),

                      GestureDetector(
                        onTap: () async{
                          // final cameras = await availableCameras();
                          // final permissionRequestStatus = await Permission.photos.request(); //this will help in showing the gallery images
                          // if(permissionRequestStatus == PermissionStatus.granted){
                          //   Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType = "MOMENT_IMAGE_EDIT";
                          //   Provider.of<MomentIdProvider>(context, listen: false).momentid = moment.id;
                          //   Navigations.goToScreen(
                          //     context, 
                          //     ChangeMomentImage(camera: cameras.first, momentId: moment.id),
                          //   );
                          // }

                          final permissionStatus = await Permission.camera.request();

                          if(permissionStatus.isGranted){
                            final cameras = await availableCameras();
                            Provider.of<MomentIdProvider>(context, listen: false).momentid = widget.moment.id;
                            Provider.of<TakePictureTypeProvider>(context, listen: false).takePictureType = MEMORY_IMAGE_ADD;
                            Navigations.goToScreen(context, AddMemory(cameras: cameras));
                          }   
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.LIGHT_GREY_SHADE2,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Icon(Icons.camera_alt),
                        ),
                      )
                    ],
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

   void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
}