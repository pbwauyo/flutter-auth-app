import 'package:get/get.dart';

class ContactSliderController extends GetxController {
  var sliderValue = 0.0.obs;

  updateValue(double newValue){
    sliderValue.value = newValue;
  }
}