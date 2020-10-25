import 'package:get/get.dart';

class SelectedInterestsController extends GetxController {
  final selectedInterests = <String>[].obs;

  addCategory(String newInterest){
    selectedInterests.add(newInterest);
  }

  removeCategory(String interest){
    selectedInterests.remove(interest);
  }
}