import 'dart:async';

import 'package:auth_app/getxcontrollers/categories_controller.dart';
import 'package:auth_app/getxcontrollers/interests_search_controller.dart';
import 'package:auth_app/models/category.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/category_widget.dart';
import 'package:auth_app/widgets/custom_input_field.dart';
import 'package:auth_app/widgets/custom_text_view.dart';
import 'package:auth_app/widgets/drag_placeholder.dart';
import 'package:auth_app/widgets/rounded_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'calendar_permission.dart';

const TAG = "INTERESTS_V2";

class InterestsV2 extends StatefulWidget {
  @override
  _InterestsV2State createState() => _InterestsV2State();
}

class _InterestsV2State extends State<InterestsV2> {
  final _searchTextController = TextEditingController();
  final CategoriesController _categoriesController = Get.find();
  final InterestsSearchController _categoriesSearchController = Get.put(InterestsSearchController());
  Timer _debounce;
  List<Map<String, dynamic>> _selectedDragDetailsList;
  Category _currentDragCategory;
  

  @override
  void initState() {
    super.initState();
    _selectedDragDetailsList = initDragDetails();
    
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
              text: "Drag below 9 or more categories that represent what you're interested in.",
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

          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            child: Obx((){
              return Wrap(
                spacing: 3.0,
                runSpacing: 3.0,
                children: _categoriesController.categories.map(
                  (category) => GestureDetector(
                    onTap: (){
                      _categoriesSearchController.updateEmptyDragContainers(category: category.name);
                    },
                    child: DragTarget<Category>(
                      key: Key(category.name),
                      builder: (context, acceptedData, rejectedData){
                        // if(_currentDragCategory == null){
                        //   return DragPlaceholder();
                        // }

                        // final index = _selectedDragDetailsList.indexWhere((element) => element["category"] == _currentDragCategory.name);
                        // final accepted = _selectedDragDetailsList[index]["accepted"];

                        // if(!accepted){
                        //   return DragPlaceholder();
                        // }
                        // else{
                          return Draggable<Category>(
                            key: Key(category.name),
                            child: CategoryWidget(category: category),
                            feedback: CategoryWidget(category: category),
                            childWhenDragging: DragPlaceholder(),
                            onDragStarted: (){
                              // print("DRAG START");
                              _currentDragCategory = category;
                            },
                            onDragEnd: (details){
                              // print("DRAG END");
                              // print("BEFORE DRAG END: ${_currentDragCategory.name}");
                              // _currentDragCategory = null;
                            },
                            onDragCompleted: () {
                              final index = _selectedDragDetailsList.indexWhere((element) => element["category"] == category.name);
                              _selectedDragDetailsList[index]["accepted"] = true;
                              print("DRAG COMPLETED");
                            },
                            data: category,
                          );
                        // }
                      },
                      onWillAccept: (data) {
                        return true;
                      },
                    ),
                  )
                ).toList(),
              );
            }),
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 15),
              child: CustomTextView(
                text: "Drag below",
                bold: true,
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            child: GetBuilder<InterestsSearchController>(
              builder: (value) {
                return Wrap(
                  spacing: 3.0,
                  runSpacing: 3.0,
                  children: _categoriesSearchController.emptyDragContainers.map(
                    (emptyContainer) {
                      if(emptyContainer['category'].isEmpty){
                        return DragTarget<Category>(
                          // key: Key(emptyContainer["category"]),
                          builder: (context, acceptedData, rejectedData){
                            return DragPlaceholder();
                          },
                          onWillAccept: (category){
                            return true;
                          },
                          onAccept: (category){
                            _categoriesSearchController.updateEmptyDragContainers(category: category.name);
                          },
                        );
                      }else{
                        final category = _categoriesController.categories.firstWhere((cat) => cat.name == emptyContainer["category"]);
                        return GestureDetector(
                          onTap: (){
                            _categoriesSearchController.updateEmptyDragContainers(category: category.name, removeCategory: true);
                          },
                          child: Draggable(
                            feedback: CategoryWidget(category: category),
                            // childWhenDragging: ,
                            child: CategoryWidget(category: category),
                            onDragEnd: (details){
                              _categoriesSearchController.updateEmptyDragContainers(category: category.name, removeCategory: true);
                            },
                          ),
                        );
                      }
                    }
                  ).toList(),
                );
              }
            ),
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
                  Navigations.goToScreen(context, CalendarPermission());
                }
              ),
            ),
          ),

        ],
      ),
    );
  }

  List<Map<String, dynamic>> initDragDetails(){
    final List<Map<String, dynamic>> list = [];
    _categoriesController.categories.forEach((category) {
      list.add({
        "category" : category.name,
        "accepted" : false
      });
     });

     return list;
  }
}