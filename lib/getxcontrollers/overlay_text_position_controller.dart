import 'package:get/get.dart';

class OverlayTextPositionController extends GetxController {
  var top = 0.0.obs;
  var left = 0.0.obs;

  resetPosition(){
    top.value = 0.0;
    left.value = 0.0;
  }
}