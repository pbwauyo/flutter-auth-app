import 'package:auth_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class InterestsSearchController extends GetxController{
  final interests = <String>[].obs;
  List<Map<String, String>> emptyDragContainers = [];
  

  @override
  onInit(){
    interests.addAll(Constants.interests);
    emptyDragContainers = [
      {
        '1' : '1',
        'category' : ""
      },
      {
        '2' : '2',
        'category' : ''
      },
      {
        '3' : '3',
        'category' : ''
      },
      {
        '4' : '4',
        'category' : ''
      },
      {
        '5' : '5',
        'category' : ''
      },
      {
        '6' : '6',
        'category' : ''
      },
      {
        '7' : '7',
        'category' : ''
      },
      {
        '8' : '8',
        'category' : ''
      },
      {
        '9' : '9',
        'category' : ''
      }
    ];
  }

  updateInterestsList(String query){
    if(query.trim().length <= 0){
      interests.clear();
      interests.addAll(Constants.interests);
    }else {
      final filteredInterests = Constants.interests
            .where((interest) => interest.isCaseInsensitiveContains(query)).toList();
      interests.clear();
      interests.addAll(filteredInterests);
    }
  }

  updateEmptyDragContainers({bool removeCategory = false, String category}){
    print("CATEGORIES: $emptyDragContainers");
    if(removeCategory){
      emptyDragContainers.firstWhere((element) => element['category'] == category)['category'] = '';
    }else{
      emptyDragContainers.firstWhere((element) => element['category'] == '')['category'] = category;
    }
    update();
  }
}