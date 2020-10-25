import 'package:auth_app/models/moment.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';

class MomentWidget extends StatelessWidget {
  final Moment moment;

  MomentWidget({@required this.moment});

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 8),
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
                image: moment.imageUrl.isNotEmpty ? 
                  NetworkImage(moment.imageUrl) :
                  AssetImage(Constants.momentImages[moment.category]),
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
                text: moment.title,
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
                        text: moment.location,
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
                        text: moment.dateTime,
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

                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.LIGHT_GREY_SHADE2,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Icon(Icons.camera_alt),
                    )
                  ],
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}