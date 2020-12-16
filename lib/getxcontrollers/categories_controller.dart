import 'package:auth_app/models/category.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController{
  final categories = <Category>[].obs;
  final allCategories = <Category>[].obs;

  @override
  onInit(){
    categories.addAll(Constants.categories);
    allCategories.addAll(Constants.categories);
  }

  updateCategoriesList(String query){
    if(query.trim().length <= 0){
      categories.clear();
      categories.addAll(Constants.categories);
    }else {
      final filteredCategories = Constants.categories
            .where((category) => category.name.isCaseInsensitiveContains(query)).toList();
      print("FILTERED CATEGORIES: $filteredCategories");
      categories.clear();
      categories.addAll(filteredCategories);
    }
  }
}