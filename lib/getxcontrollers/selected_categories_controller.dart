import 'package:get/get.dart';

class SelectedCategoriesController extends GetxController {
  final selectedCategories = <String>[].obs;

  addCategory(String newCategory){
    selectedCategories.add(newCategory);
  }

  removeCategory(String category){
    selectedCategories.remove(category);
  }
}