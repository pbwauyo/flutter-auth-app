import 'dart:async';

import 'package:auth_app/getxcontrollers/interests_search_controller.dart';
import 'package:auth_app/getxcontrollers/selected_interests_controller.dart';
import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/pages/calendar_permission.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/utils/constants.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:rxdart/subjects.dart';

class Interests extends StatefulWidget {
  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  final _searchTextController = TextEditingController();

  final SelectedInterestsController _selectedCategoriesController = Get.put(SelectedInterestsController());

  final InterestsSearchController _categoriesSearchController = Get.put(InterestsSearchController());

  Timer _debounce;

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(AssetNames.APP_LOGO_SVG, width: 100, height: 35,),
        elevation: 0.0,
        backgroundColor: Colors.white
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: CustomTextView(
                text: "Things I like!",
                fontSize: 18,
                bold: true,
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: CustomTextView(
              text: "Choose 9 or more categories that represent what you're interested in.",
              textAlign: TextAlign.center,
            ),
          ),

          Container(
            width: screenWidth * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: AppColors.LIGHT_GREY
            ),
            child: CustomInputField(
              placeholder: "Search things", 
              controller: _searchTextController,
              prefixIcon: Icons.search,
              textAlign: TextAlign.start,
              onChanged: (value){
                if(_debounce?.isActive ?? false) _debounce.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), (){
                  _categoriesSearchController.updateInterestsList(value);
                });
              },
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 15),
                  child: CustomTextView(
                    text: "Selected",
                    bold: true,
                  ),
                ),
              ),

              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 60.0,
                    maxHeight: 250.0,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(),
                    child: Obx(() => Wrap(
                      spacing: 4.0,
                      children: _selectedCategoriesController.selectedInterests.length <= 0 ?
                        [ 
                          Center(
                            child: CustomTextView(text: "No Selected categories yet"),
                          )
                        ] :
                       _selectedCategoriesController.selectedInterests.map(
                        (category) => Chip(
                            label: CustomTextView(text: category),
                            deleteIcon: Icon(Icons.clear),
                            onDeleted: (){
                              _selectedCategoriesController.removeCategory(category);
                            },
                            backgroundColor: AppColors.PRIMARY_COLOR,
                          )
                        ).toList()
                    ),)
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 15),
                  child: CustomTextView(
                    text: "Select from below list",
                    bold: true,
                  ),
                ),
              ),

              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 400 
                ),
                child: Obx((){
                  return ListView(
                    padding: const EdgeInsets.only(left: 35,),
                    children: _categoriesSearchController.interests.length <= 0 ?
                    [
                      Center(
                        child: EmptyResultsText(message: "No matching categories",),
                      )
                    ] :
                    
                    _categoriesSearchController.interests.map((category) {
                      return Obx((){
                        return Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: InterestCategoryItem(
                            isSelected: _selectedCategoriesController.selectedInterests.contains(category),
                            label: category, 
                            onTap: (currentItem){
                              _selectedCategoriesController.addCategory(currentItem);
                            }
                          ),
                        );
                      });
                     }).toList()
                  );
                })
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: RoundedRaisedButton(
                    borderRadius: 25,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    text: "Next", 
                    onTap: () async{
                      Navigations.goToScreen(context, Home());
                    }
                  ),
                ),
              ),
            ],
          ),    
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchTextController.dispose();
    super.dispose();
  }
}