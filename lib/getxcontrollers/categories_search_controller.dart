import 'package:auth_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CategoriesSearchController extends GetxController{
  final categories = <String>[].obs;

  @override
  onInit(){
    categories.addAll(Constants.interestsCategories);
  }

  updateCategoriesList(String query){
    if(query.trim().length <= 0){
      categories.clear();
      categories.addAll(Constants.interestsCategories);
    }else {
      final filteredCategories = Constants.interestsCategories
            .where((category) => category.isCaseInsensitiveContains(query)).toList();
      print("FILTERED CATEGORIES: $filteredCategories");
      categories.clear();
      categories.addAll(filteredCategories);
    }
  }
}