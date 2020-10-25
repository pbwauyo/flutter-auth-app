import 'package:auth_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class InterestsSearchController extends GetxController{
  final interests = <String>[].obs;

  @override
  onInit(){
    interests.addAll(Constants.interests);
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
}