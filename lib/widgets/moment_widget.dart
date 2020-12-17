import 'package:auth_app/cubit/home_cubit.dart';
import 'package:auth_app/getxcontrollers/create_moment_controller.dart';
import 'package:auth_app/getxcontrollers/selected_calendar_controller.dart';
import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/pages/add_memory.dart';
import 'package:auth_app/pages/change_moment_image.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/moment_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/repos/moment_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/friends_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'contact_avatar.dart';
import 'error_text.dart';

class MomentWidget extends StatefulWidget {
  final Moment moment;

  MomentWidget({@required this.moment});

  @override
  _MomentWidgetState createState() => _MomentWidgetState();
}

class _MomentWidgetState extends State<MomentWidget> {
  final _momentRepo = MomentRepo();
  final CreateMomentController _createMomentController = Get.find();
  final SelectedCalendarController _selectedCalendarController = Get.find();

  var _tapPosition;

  @override
  Widget build(BuildContext context) {

    final homeCubit = context.bloc<HomeCubit>();

    return GestureDetector(
      onTap: (){
        homeCubit.goToMomentDetailsScreen(widget.moment);
        Provider.of<MomentProvider>(context, listen: false).moment = widget.moment; //will be used when back button is pressed
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
            PopupMenuItem(value: 1, child: CustomTextView(text: "DELETE", textColor: Colors.red, bold: true,),),
            PopupMenuItem(value: 2, child: CustomTextView(text: "EDIT", textColor: Colors.green, bold: true,))
          ]
        ).then((value){
          if(value == 1){
            _momentRepo.deleteMoment(
              momentId: widget.moment.id, 
              calendarId: widget.moment.calendarId, 
              eventId: widget.moment.momentCalenderId
            );
          }
          else {
            final imageUrl = widget.moment.imageUrl;
            if(imageUrl == null || imageUrl.isEmpty){
              _createMomentController.categoryName.value = widget.moment.category;
            }
            else {
              Provider.of<FilePathProvider>(context, listen: false).filePath = imageUrl;
            }
            _selectedCalendarController.calendarId.value = widget.moment.calendarId ?? "";
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
              child: FutureBuilder<ImageProvider>(
                future: Methods.generateNetworkImageProvider(mediaUrl: widget.moment.imageUrl, category: widget.moment.category),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        image: DecorationImage(
                          image: snapshot.data,
                          fit: BoxFit.cover
                        )
                      ),
                    );
                  }else if(snapshot.hasError){
                    return Center(
                      child: ErrorText(error: "${snapshot.error}"),
                    );
                  }
                  return Center(
                    child: CustomProgressIndicator(),
                  );
                  
                }
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
                          text: widget.moment.startDateTime,
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
                      FriendsWidget(
                        contacts: widget.moment.attendees.map((attendee) => HapprContact.fromMap(attendee.cast<String, dynamic>())).toList()
                      )
                    ],
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context, ) {
                          return GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                context: context, 
                                builder: (context){
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10, bottom: 8),
                                          child: Icon(Icons.clear, color: Colors.black),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: widget.moment.attendees.map((attendee) => HapprContact.fromMap(attendee)).toList().map(
                                          (contact) => GestureDetector(
                                            onTap: (){
                                              Methods.showCustomSnackbar(context: context, message: "Moment shared successfully");
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 6, right: 6, top: 5, ),
                                              child: ListTile(
                                                leading: ContactAvatar(
                                                  initials: contact.initials,
                                                  size: 30,
                                                ),
                                                title: CustomTextView(
                                                  fontSize: 13,
                                                  text: contact.displayName
                                                ),
                                              )
                                            ),
                                          )
                                        ).toList(),
                                      ),
                                    ],
                                  );
                                }
                              );
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
                              child: Icon(Icons.share),
                            ),
                          );
                        },
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