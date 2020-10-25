import 'package:auth_app/cubit/home_cubit.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateHappyMoment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeCubit = context.bloc<HomeCubit>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 220,
                  margin: const EdgeInsets.only(right: 5),
                  child: CustomCard(
                    image: AssetNames.CUSTOM_MOMENT, 
                    title: "Custom HappyMoment", 
                    body: "Lorem ipsum dolor sit amet, conse",
                    onTap: (){
                      homeCubit.goToPickCategoryScreen();
                    },
                  ),
                ),

                Container(
                  width: 150,
                  height: 220,
                  margin: const EdgeInsets.only(left: 5),
                  child: CustomCard(
                    image: AssetNames.ONE_CLICK_MOMENT, 
                    title: "1-Click HappyMoment", 
                    body: "Lorem ipsum dolor sit amet, conse"
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 220,
                margin: const EdgeInsets.only(right: 5),
                child: CustomCard(
                  image: AssetNames.HAPPENING_NOW, 
                  title: "Happening Now", 
                  body: "Lorem ipsum dolor sit amet, conse"
                ),
              ),

              Container(
                width: 150,
                height: 220,
                margin: const EdgeInsets.only(left: 5),
                child: CustomCard(
                  image: AssetNames.QR_CODE, 
                  title: "Add throughQR Code", 
                  body: "Lorem ipsum dolor sit amet, conse"
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}