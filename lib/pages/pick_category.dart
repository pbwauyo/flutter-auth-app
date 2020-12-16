import 'dart:async';

import 'package:auth_app/cubit/home_cubit.dart';
import 'package:auth_app/getxcontrollers/categories_controller.dart';
import 'package:auth_app/getxcontrollers/create_moment_controller.dart';
import 'package:auth_app/getxcontrollers/interests_search_controller.dart';
import 'package:auth_app/getxcontrollers/selected_interests_controller.dart';
import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/pages/calendar_permission.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/category_widget.dart';
import 'package:auth_app/widgets/contact_rating_widget.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/empty_results_text.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:auth_app/widgets/interest_category_item.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class PickCategory extends StatefulWidget {
  @override
  _PickCategoryState createState() => _PickCategoryState();
}

class _PickCategoryState extends State<PickCategory> {
  final _searchTextController = TextEditingController();
  final CategoriesController _categoriesController = Get.find();
  final CreateMomentController createMomentController = Get.find();

  Timer _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final homeCubit = context.bloc<HomeCubit>();

    return Column(
      children: [

        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: CustomTextView(
            text: "Pick a category or ask happr for assistance.",
            textAlign: TextAlign.center,
            fontSize: 20,
          ),
        ),

        Container(
          width: screenWidth * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: AppColors.LIGHT_GREY
          ),
          child: CustomInputField(
            placeholder: "Search categories", 
            controller: _searchTextController,
            prefixIcon: Icons.search,
            textAlign: TextAlign.start,
            onChanged: (value){
              if(_debounce?.isActive ?? false) _debounce.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), (){
                _categoriesController.updateCategoriesList(value);
              });
            },
          ),
        ),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            child: Obx((){
              return Wrap(
                spacing: 3.0,
                runSpacing: 3.0,
                children: _categoriesController.categories.map(
                  (category) => GestureDetector(
                    onTap: (){
                      createMomentController.categoryName.value = category.name;
                      homeCubit.goToAddMomentDetailsScreen();
                    },
                    child: CategoryWidget(category: category))
                  ).toList(),
              );
            }),
          ),
        ),

        // Center(
        //   child: Container(
        //     width: screenWidth * 0.6,
        //     margin: const EdgeInsets.only(bottom: 35),
        //     child: RoundedRaisedButton(
        //       text: "Select for me", 
        //       onTap: (){

        //       },
        //       textColor: AppColors.PRIMARY_COLOR,
        //       borderColor: AppColors.PRIMARY_COLOR,
        //       bgColor: Colors.white,
        //     ),
        //   ),
        // )
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchTextController.dispose();
    super.dispose();
  }
}