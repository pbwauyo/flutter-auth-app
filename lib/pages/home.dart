import 'package:auth_app/cubit/home_cubit.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/pages/add_moment_details.dart';
import 'package:auth_app/pages/create_happy_moment.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/location_permission.dart';
import 'package:auth_app/pages/pick_category.dart';
import 'package:auth_app/repos/moment_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:auth_app/widgets/moment_widget.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatelessWidget {
  final _momentRepo = MomentRepo();


  @override
  Widget build(BuildContext context) {

    final homeCubit = context.bloc<HomeCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(AssetNames.APP_LOGO_SVG, width: 100, height: 35,),
        elevation: 0.0,
        backgroundColor: Colors.white
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(Icons.add,
          color: Colors.black,
        ),
        backgroundColor: AppColors.PRIMARY_COLOR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 40),
                    child: SvgPicture.asset(
                      AssetNames.HOME_SVG, 
                      width: 32, 
                      height: 32,
                    ),
                  ),

                  Container(
                    child: SvgPicture.asset(
                      AssetNames.ELLIPSE_SVG, 
                      width: 32, 
                      height: 32,
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      AssetNames.BELL_SVG, 
                      width: 32, 
                      height: 32,
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(right: 10, left: 40),
                    child: SvgPicture.asset(
                      AssetNames.MENU_SVG, 
                      width: 32, 
                      height: 32,
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if(state is HomeCreateMoment){
                return CreateHappyMoment();
              }
              else if(state is HomePickCategory){
                return PickCategory();
              }
              else if(state is HomeMomentDetails){
                return AddMomentDetails();
              }
              else {
                return StreamBuilder<QuerySnapshot>(
                  stream: _momentRepo.getMomentsAsStream(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      final data = snapshot.data;
                      final docs = data.docs;

                      if(docs.length > 0){
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: docs.length,
                          itemBuilder: (context, index){
                            final moment = Moment.fromMap(docs[index].data());
                            return MomentWidget(moment: moment);
                          }
                        );
                      }
                      else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 40),
                                width: 90,
                                height: 90,
                                child: SvgPicture.asset(AssetNames.HAPPY_SVG, width: 110, height: 110,),
                              ),
                            ),

                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: CustomTextView(
                                  text: "Create your first happy moment.",
                                  fontSize: 18,
                                  bold: true,
                                ),
                              ),
                            ),

                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: RoundedRaisedButton(
                                    borderRadius: 25,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    text: "Create", 
                                    onTap: () async{
                                      homeCubit.goToCreateMomentScreen();                              
                                    }
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    else if(snapshot.hasError){
                      return Center(
                        child: ErrorText(error: "${snapshot.error}"),
                      );
                    }
                    else {
                      return Center(
                        child: CustomProgressIndicator(),
                      );
                    }
                  }
                );
              }
            }
          ),

           Positioned(
            bottom: 10,
            right: 10,
            child: Ring(
              size: 25,
              width: 4,
            )
          ),

          Positioned(
            bottom: 60,
            left: -15,
            child: Ring(
              size: 50,
              width: 4,
            )
          ),
        ],
      ),
    );
  }
}